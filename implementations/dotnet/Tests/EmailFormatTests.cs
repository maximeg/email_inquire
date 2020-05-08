using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace EmailInquire.Tests
{
    public class EmailFormatTests
    {
        [Fact]
        public void AddressValid()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@domain.xyz");
            Assert.True(result.IsValid);
        }
        
        [Fact]
        public void AddressInvalidNull()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(null);
            Assert.True(result.IsInvalid);
        }
        
        [Fact]
        public void AddressInvalidEmpty()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("");
            Assert.True(result.IsInvalid);
        }
        
        [Fact]
        public void AddressInvalidOnlySpaces()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("      ");
            Assert.True(result.IsInvalid);
        }
        
        [Fact]
        public void AddressInvalidWithoutAt()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("a");
            Assert.True(result.IsInvalid);
            result = inquirer.Validate("john.doedomain.com");
            Assert.True(result.IsInvalid);
        }

        [Fact]
        public void AddressInvalidOnlyAt()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("@");
            Assert.True(result.IsInvalid);
        }
        
        [Fact]
        public void AddressInvalidOnlyAtAndSpaces()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("  @  ");
            Assert.True(result.IsInvalid);
        }
        
        [Fact]
        public void AddressSeveralAts()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john@doe@domain.com");
            Assert.True(result.IsInvalid);
        }
        
        [Fact]
        public void AddressValidUpTo255()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe.jr@" + string.Concat(Enumerable.Repeat("blah.", 48)) + "com");
            Assert.True(result.IsValid);
        }
        
        [Fact]
        public void AddressInvalidOver255()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.does.jr@" + string.Concat(Enumerable.Repeat("blah.", 48)) + "com");
            Assert.True(result.IsInvalid);
        }
        
        

    }
}