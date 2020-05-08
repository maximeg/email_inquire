using Xunit;

namespace EmailInquire.Tests
{
    public class UkTldTests
    {
        [Theory]
        [InlineData("john.doe@domain.ci.uk")]
        [InlineData("john.doe@domain.xo.uk")]
        [InlineData("john.doe@domain.zz.uk")]
        [InlineData("john.doe@domainco.uk")]
        public void CoUkTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@domain.co.uk", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@domain.uk")]
        [InlineData("john.doe@domain.ac.uk")]
        [InlineData("john.doe@domain.co.uk")]
        [InlineData("john.doe@domain.gov.uk")]
        [InlineData("john.doe@domain.judiciary.uk")]
        [InlineData("john.doe@domain.ltd.uk")]
        [InlineData("john.doe@domain.me.uk")]
        [InlineData("john.doe@domain.mod.uk")]
        [InlineData("john.doe@domain.net.uk")]
        [InlineData("john.doe@domain.nhs.uk")]
        [InlineData("john.doe@domain.nic.uk")]
        [InlineData("john.doe@domain.org.uk")]
        [InlineData("john.doe@domain.parliament.uk")]
        [InlineData("john.doe@domain.plc.uk")]
        [InlineData("john.doe@domain.police.uk")]
        [InlineData("john.doe@domain.sch.uk")]
        public void CoUkValid(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsValid);
        }
        
        [Theory]
        [InlineData("john.doe@aol.uk", "john.doe@aol.co.uk")]
        [InlineData("john.doe@blueyonder.uk", "john.doe@blueyonder.co.uk")]
        [InlineData("john.doe@hotmail.uk", "john.doe@hotmail.co.uk")]
        [InlineData("john.doe@live.uk", "john.doe@live.co.uk")]
        [InlineData("john.doe@yahoo.uk", "john.doe@yahoo.co.uk")]
        public void CoUkPairHint(string email, string test)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal(test, result.Email);
        }
    }
}