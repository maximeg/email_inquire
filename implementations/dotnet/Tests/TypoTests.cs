using Xunit;

namespace EmailInquire.Tests
{
    public class TypoTests
    {
        [Theory]
        [InlineData("john.doe@free.com")]
        [InlineData("john.doe@free.fe")]
        [InlineData("john.doe@frer.fr")]
        [InlineData("john.doe@gree.fr")]
        public void FreeFrTypos(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@free.fr", result.Email);
        }

        [Theory]
        [InlineData("john.doe@gmail.com")]
        [InlineData("john.doe@googlemail.com")]
        public void GmailTyposValid(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsValid);
        }

        [Theory]
        [InlineData("john.doe@email.com")]
        [InlineData("john.doe@fmail.com")]
        [InlineData("john.doe@g.mail.com")]
        [InlineData("john.doe@gail.com")]
        [InlineData("john.doe@gamail.com")]
        [InlineData("john.doe@gamil.com")]
        [InlineData("john.doe@gemail.com")]
        [InlineData("john.doe@ggmail.com")]
        [InlineData("john.doe@glail.com")]
        [InlineData("john.doe@gmai.com")]
        [InlineData("john.doe@gmaik.com")]
        [InlineData("john.doe@gmail.cim")]
        [InlineData("john.doe@gmail.clm")]
        [InlineData("john.doe@gmail.cm")]
        [InlineData("john.doe@gmail.co")]
        [InlineData("john.doe@gmail.col")]
        [InlineData("john.doe@gmail.com.com")]
        [InlineData("john.doe@gmail.comcom")]
        [InlineData("john.doe@gmail.comm")]
        [InlineData("john.doe@gmail.con")]
        [InlineData("john.doe@gmail.cop")]
        [InlineData("john.doe@gmail.cpm")]
        [InlineData("john.doe@gmail.fr")]
        [InlineData("john.doe@gmail.om")]
        [InlineData("john.doe@gmail.vom")]
        [InlineData("john.doe@gmail.xom")]
        [InlineData("john.doe@gmaim.com")]
        [InlineData("john.doe@gmaio.com")]
        [InlineData("john.doe@gmaol.com")]
        [InlineData("john.doe@gmaul.com")]
        [InlineData("john.doe@gmil.com")]
        [InlineData("john.doe@gmsil.com")]
        [InlineData("john.doe@gmail.co.za")]
        [InlineData("john.doe@gmzil.com")]
        [InlineData("john.doe@gnail.com")]
        [InlineData("john.doe@google.fr")]
        [InlineData("john.doe@hmail.com")]
        public void GmailTyposHints(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@gmail.com", result.Email);
        }

        [Theory]
        //[InlineData("john.doe@gmal.fr")] TODO: verify algo
        [InlineData("john.doe@gmial.com")]
        public void GmailTyposInvalid(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsInvalid);
        }
        
        [Theory]
        [InlineData("john.doe@hitmail.com")]
        [InlineData("john.doe@homail.com")]
        [InlineData("john.doe@homtail.com")]
        [InlineData("john.doe@hormail.com")]
        [InlineData("john.doe@hotail.com")]
        [InlineData("john.doe@hotamil.com")]
        [InlineData("john.doe@hotmaik.com")]
        [InlineData("john.doe@hotmail.col")]
        [InlineData("john.doe@hotmail.con")]
        [InlineData("john.doe@hotmail.cop")]
        [InlineData("john.doe@hotmal.com")]
        [InlineData("john.doe@hotmaol.com")]
        [InlineData("john.doe@hotmaul.com")]
        [InlineData("john.doe@hotmil.com")]
        [InlineData("john.doe@jotmail.com")]
        [InlineData("john.doe@otmail.com")]
        public void HotmailComTyposHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@hotmail.com", result.Email);
        }

        [Theory]
        [InlineData("john.doe@botmail.fr")]
        [InlineData("john.doe@gotmail.fr")]
        [InlineData("john.doe@hitmail.fr")]
        [InlineData("john.doe@homail.fr")]
        [InlineData("john.doe@homtail.fr")]
        [InlineData("john.doe@hormail.fr")]
        [InlineData("john.doe@hotail.fr")]
        [InlineData("john.doe@hotamail.fr")]
        [InlineData("john.doe@hotamil.fr")]
        [InlineData("john.doe@hotlail.fr")]
        [InlineData("john.doe@hotmaail.fr")]
        [InlineData("john.doe@hotmai.fr")]
        [InlineData("john.doe@hotmaik.fr")]
        [InlineData("john.doe@hotmail.dr")]
        [InlineData("john.doe@hotmail.fe")]
        [InlineData("john.doe@hotmail.ff")]
        [InlineData("john.doe@hotmail.frr")]
        [InlineData("john.doe@hotmail.ft")]
        [InlineData("john.doe@hotmail.gr")]
        [InlineData("john.doe@hotmaill.fr")]
        [InlineData("john.doe@hotmaim.fr")]
        [InlineData("john.doe@hotmaio.fr")]
        [InlineData("john.doe@hotmal.fr")]
        [InlineData("john.doe@hotmaol.fr")]
        [InlineData("john.doe@hotmaul.fr")]
        [InlineData("john.doe@hotmil.fr")]
        [InlineData("john.doe@hotmsil.fr")]
        [InlineData("john.doe@hotmzil.fr")]
        [InlineData("john.doe@htmail.fr")]
        [InlineData("john.doe@jotmail.fr")]
        public void HotmailFrTyposHints(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@hotmail.fr", result.Email);
        }

        [Theory]
        [InlineData("john.doe@hotmai.com")]
        public void HotmailTyposInvalid(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsInvalid);
        }
        
        [Theory]
        [InlineData("john.doe@cloud.com")]
        public void IcloudTyposHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@icloud.com", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@lapost.net")]
        [InlineData("john.doe@laposte.com")]
        [InlineData("john.doe@laposte.fr")]
        [InlineData("john.doe@laposte.ne")]
        [InlineData("john.doe@laposte.ner")]
        [InlineData("john.doe@lapostr.net")]
        [InlineData("john.doe@lapostz.net")]
        [InlineData("john.doe@lapote.net")]
        [InlineData("john.doe@lappste.net")]
        public void LaposteTyposHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@laposte.net", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@liv.com")]
        [InlineData("john.doe@live.co")]
        [InlineData("john.doe@livr.com")]
        [InlineData("john.doe@windowslive.com")]
        public void LiveComTyposHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@live.com", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@liv.fr")]
        [InlineData("john.doe@live.fe")]
        [InlineData("john.doe@live.ff")]
        [InlineData("john.doe@live.ft")]
        [InlineData("john.doe@livr.fr")]
        public void LiveFrTyposHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@live.fr", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@irange.fr")]
        [InlineData("john.doe@oange.fr")]
        [InlineData("john.doe@oeange.fr")]
        [InlineData("john.doe@orage.fr")]
        [InlineData("john.doe@oranfe.fr")]
        [InlineData("john.doe@orange.fe")]
        [InlineData("john.doe@orange.ff")]
        [InlineData("john.doe@orange.ft")]
        [InlineData("john.doe@orange.gr")]
        [InlineData("john.doe@orangr.fr")]
        [InlineData("john.doe@ornge.fr")]
        [InlineData("john.doe@prange.fr")]
        public void OrangeFrTyposHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@orange.fr", result.Email);
        }
        
         [Fact]
        public void ProposedDoubleTldHint()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@domain.com.com");
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@domain.com", result.Email);
        }
        
        [Fact]
        public void ProposedTypoHint()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@aliceafsl.fr");
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@aliceadsl.fr", result.Email);
        }
        
        [Fact]
        public void ProposedMissedLetterHint()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@al.com");
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@aol.com", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@ail.com")]
        [InlineData("john.doe@ain.com")]
        public void ProposedMisplacedLetterHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@aim.com", result.Email);
        }
        
        [Fact]
        public void ProposedTypoLetterHint()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@nulericable.fr");
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@numericable.fr", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@sf.fr")]
        [InlineData("john.doe@sfe.fr")]
        [InlineData("john.doe@sfr.com")]
        [InlineData("john.doe@sfr.fe")]
        [InlineData("john.doe@sft.fr")]
        public void ProposedThreeWordsTldTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@sfr.fr", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@outloo.com")]
        [InlineData("john.doe@outloock.com")]
        public void OutlookComTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@outlook.com", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@iutlook.fr")]
        [InlineData("john.doe@oitlook.fr")]
        [InlineData("john.doe@oulook.fr")]
        [InlineData("john.doe@outllook.fr")]
        [InlineData("john.doe@outlok.fr")]
        [InlineData("john.doe@outloo.fr")]
        [InlineData("john.doe@outlook.fe")]
        [InlineData("john.doe@outlook.ft")]
        [InlineData("john.doe@outlouk.fr")]
        public void OutlookFrTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@outlook.fr", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@wanado.fr")]
        [InlineData("john.doe@wanadoi.fr")]
        [InlineData("john.doe@wanadoo.com")]
        [InlineData("john.doe@wanadoo.dr")]
        [InlineData("john.doe@wanadoo.fe")]
        [InlineData("john.doe@wanadoo.ff")]
        [InlineData("john.doe@wanadop.fr")]
        [InlineData("john.doe@wanasoo.fr")]
        [InlineData("john.doe@wandoo.fr")]
        public void WanadooTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@wanadoo.fr", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@yahoo.co.uk")]
        [InlineData("john.doe@yahoo.com")]
        [InlineData("john.doe@yahoo.fr")]
        [InlineData("john.doe@ymail.com")]
        public void YahooValid(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsValid);
        }
        
        [Theory]
        [InlineData("john.doe@yahooo.com")]
        public void YahooComTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@yahoo.com", result.Email);
        }
        
        
        [Theory]
        [InlineData("john.doe@tahoo.fr")]
        [InlineData("john.doe@uahoo.fr")]
        [InlineData("john.doe@yaboo.fr")]
        [InlineData("john.doe@yaho.fr")]
        [InlineData("john.doe@yahoi.fr")]
        [InlineData("john.doe@yahol.fr")]
        [InlineData("john.doe@yahoo.fe")]
        [InlineData("john.doe@yahoo.ff")]
        [InlineData("john.doe@yahoo.ft")]
        [InlineData("john.doe@yahoo.gr")]
        [InlineData("john.doe@yahooo.fr")]
        [InlineData("john.doe@yahou.fr")]
        [InlineData("john.doe@yajoo.fr")]
        [InlineData("john.doe@yaoo.fr")]
        [InlineData("john.doe@yhaoo.fr")]
        public void YahooFrTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@yahoo.fr", result.Email);
        }
        
        [Theory]
        [InlineData("john.doe@yahoo.uk")]
        [InlineData("john.doe@yhoo.co.uk")]
        public void YahooCoUkTypoHint(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@yahoo.co.uk", result.Email);
        }
        
        
        
    }
}