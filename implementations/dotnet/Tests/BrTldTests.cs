using Xunit;

namespace EmailInquire.Tests
{
    public class BrTldTests
    {
        [Theory]
        [InlineData("john.doe@domain.ci.br")]
        [InlineData("john.doe@domain.co.br")]
        [InlineData("john.doe@domain.combr")]
        [InlineData("john.doe@domaincom.br")]
        [InlineData("john.doe@domain.xo.br")]
        [InlineData("john.doe@domain.zz.br")]
        public void BrCommonTest(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsHint);
            Assert.Equal("john.doe@domain.com.br", result.Email);
        }

        [Theory]
        [InlineData("john.doe@domain.adm.br")]
        [InlineData("john.doe@domain.adv.br")]
        [InlineData("john.doe@domain.agr.br")]
        [InlineData("john.doe@domain.am.br")]
        [InlineData("john.doe@domain.arq.br")]
        [InlineData("john.doe@domain.art.br")]
        [InlineData("john.doe@domain.ato.br")]
        [InlineData("john.doe@domain.b.br")]
        [InlineData("john.doe@domain.bio.br")]
        [InlineData("john.doe@domain.blog.br")]
        [InlineData("john.doe@domain.bmd.br")]
        [InlineData("john.doe@domain.cim.br")]
        [InlineData("john.doe@domain.cng.br")]
        [InlineData("john.doe@domain.cnt.br")]
        [InlineData("john.doe@domain.com.br")]
        [InlineData("john.doe@domain.coop.br")]
        [InlineData("john.doe@domain.cri.br")]
        [InlineData("john.doe@domain.def.br")]
        [InlineData("john.doe@domain.ecn.br")]
        [InlineData("john.doe@domain.eco.br")]
        [InlineData("john.doe@domain.edu.br")]
        [InlineData("john.doe@domain.emp.br")]
        [InlineData("john.doe@domain.eng.br")]
        [InlineData("john.doe@domain.esp.br")]
        [InlineData("john.doe@domain.etc.br")]
        [InlineData("john.doe@domain.eti.br")]
        [InlineData("john.doe@domain.far.br")]
        [InlineData("john.doe@domain.flog.br")]
        [InlineData("john.doe@domain.fm.br")]
        [InlineData("john.doe@domain.fnd.br")]
        [InlineData("john.doe@domain.fot.br")]
        [InlineData("john.doe@domain.fst.br")]
        [InlineData("john.doe@domain.g12.br")]
        [InlineData("john.doe@domain.ggf.br")]
        [InlineData("john.doe@domain.gov.br")]
        [InlineData("john.doe@domain.imb.br")]
        [InlineData("john.doe@domain.ind.br")]
        [InlineData("john.doe@domain.inf.br")]
        [InlineData("john.doe@domain.jor.br")]
        [InlineData("john.doe@domain.jus.br")]
        [InlineData("john.doe@domain.leg.br")]
        [InlineData("john.doe@domain.lel.br")]
        [InlineData("john.doe@domain.mat.br")]
        [InlineData("john.doe@domain.med.br")]
        [InlineData("john.doe@domain.mil.br")]
        [InlineData("john.doe@domain.mp.br")]
        [InlineData("john.doe@domain.mus.br")]
        [InlineData("john.doe@domain.net.br")]
        [InlineData("john.doe@domain.nom.br")]
        [InlineData("john.doe@domain.not.br")]
        [InlineData("john.doe@domain.ntr.br")]
        [InlineData("john.doe@domain.odo.br")]
        [InlineData("john.doe@domain.org.br")]
        [InlineData("john.doe@domain.ppg.br")]
        [InlineData("john.doe@domain.pro.br")]
        [InlineData("john.doe@domain.psc.br")]
        [InlineData("john.doe@domain.psi.br")]
        [InlineData("john.doe@domain.qsl.br")]
        [InlineData("john.doe@domain.radio.br")]
        [InlineData("john.doe@domain.rec.br")]
        [InlineData("john.doe@domain.slg.br")]
        [InlineData("john.doe@domain.srv.br")]
        [InlineData("john.doe@domain.taxi.br")]
        [InlineData("john.doe@domain.teo.br")]
        [InlineData("john.doe@domain.tmp.br")]
        [InlineData("john.doe@domain.trd.br")]
        [InlineData("john.doe@domain.tur.br")]
        [InlineData("john.doe@domain.tv.br")]
        [InlineData("john.doe@domain.vet.br")]
        [InlineData("john.doe@domain.vlog.br")]
        [InlineData("john.doe@domain.wiki.br")]
        [InlineData("john.doe@domain.zlg.br")]
        public void BrValidTest(string email)
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate(email);
            Assert.True(result.IsValid);
        }

        [Fact]
        public void BrRegOpenedTest()
        {
            var inquirer = new EmailInquirer();
            var result = inquirer.Validate("john.doe@domain.br");
            Assert.True(result.IsValid);
        }
    }
}