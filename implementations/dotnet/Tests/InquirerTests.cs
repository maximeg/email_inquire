using System.IO;
using System.Reflection;
using Xunit;

namespace EmailInquire.Tests
{
    public class InquirerTests
    {
        [Theory]
        [InlineData("john.doe@0-mail.com")]
        [InlineData("john.doe@disposemail.com")]
        [InlineData("john.doe@mailinator.com")]
        [InlineData("john.doe@yopmail.com")]
        [InlineData("john.doe@yopmail.fr")]
        public void OneTimeProviders(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsInvalid);
        }

        [Fact]
        public void CustomInvalidDomains()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@my-domain.com");
            Assert.True(result.IsValid);
            inquirer.SetInvalidDomains("my-domain.com");
            result = inquirer.Validate("john.doe@my-domain.com");
            Assert.True(result.IsInvalid);
        }


        [Fact]
        public void CustomValidDomains()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@sfr.com");
            Assert.True(result.IsHint);
            result = inquirer.Validate("john.doe@example.com");
            Assert.True(result.IsInvalid);
            inquirer.SetValidDomains("sfr.com", "example.com");
            result = inquirer.Validate("john.doe@sfr.com");
            Assert.True(result.IsValid);
            result = inquirer.Validate("john.doe@example.com");
            Assert.True(result.IsValid);
        }

        [Fact]
        public void KnownInvalidDomain()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@example.com");
            Assert.True(result.IsInvalid);
        }

        [Fact]
        public void NotOverlyHelpful()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@example.ca");
            Assert.True(result.IsValid);
        }
        [Fact]
        public void SetBasePath()
        {
            Directory.SetCurrentDirectory("C:\\");
            
            var inquirer = new EmailInquirer();
            
            inquirer.SetBasePath(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location));
            var result = inquirer.Validate("john.doe@example.ca");
            Assert.True(result.IsValid);
        }
       
    }
}