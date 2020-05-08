using Xunit;

namespace EmailInquire.Tests
{
    public class JpTldTests
    {
        [Theory]
        [InlineData("john.doe@domain.ci.jp")]
        [InlineData("john.doe@domain.xo.jp")]
        [InlineData("john.doe@domain.zz.jp")]
        [InlineData("john.doe@domainco.jp")]
        public void JpCommonTest(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@domain.co.jp", result.Email);
        }

        [Theory]
        [InlineData("john.doe@domain.ac.jp")]
        [InlineData("john.doe@domain.ad.jp")]
        [InlineData("john.doe@domain.co.jp")]
        [InlineData("john.doe@domain.ed.jp")]
        [InlineData("john.doe@domain.go.jp")]
        [InlineData("john.doe@domain.gr.jp")]
        [InlineData("john.doe@domain.lg.jp")]
        [InlineData("john.doe@domain.ne.jp")]
        [InlineData("john.doe@domain.or.jp")]
        public void JpValidTest(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsValid);
        }
    }
}