# frozen_string_literal: true

require "spec_helper"

describe "Case: BR TLD" do
  %w(
    john.doe@domain.br
    john.doe@domain.ci.br
    john.doe@domain.combr
    john.doe@domaincom.br
    john.doe@domain.xo.br
    john.doe@domain.zz.br
  ).each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@domain.com.br")
    end
  end

  # https://en.wikipedia.org/wiki/.br
  # https://registro.br/dominio/categoria.html
  %w(
    john.doe@domain.adm.br
    john.doe@domain.adv.br
    john.doe@domain.agr.br
    john.doe@domain.am.br
    john.doe@domain.arq.br
    john.doe@domain.art.br
    john.doe@domain.ato.br
    john.doe@domain.b.br
    john.doe@domain.bio.br
    john.doe@domain.blog.br
    john.doe@domain.bmd.br
    john.doe@domain.cim.br
    john.doe@domain.cng.br
    john.doe@domain.cnt.br
    john.doe@domain.com.br
    john.doe@domain.coop.br
    john.doe@domain.cri.br
    john.doe@domain.def.br
    john.doe@domain.ecn.br
    john.doe@domain.eco.br
    john.doe@domain.edu.br
    john.doe@domain.emp.br
    john.doe@domain.eng.br
    john.doe@domain.esp.br
    john.doe@domain.etc.br
    john.doe@domain.eti.br
    john.doe@domain.far.br
    john.doe@domain.flog.br
    john.doe@domain.fm.br
    john.doe@domain.fnd.br
    john.doe@domain.fot.br
    john.doe@domain.fst.br
    john.doe@domain.g12.br
    john.doe@domain.ggf.br
    john.doe@domain.gov.br
    john.doe@domain.imb.br
    john.doe@domain.ind.br
    john.doe@domain.inf.br
    john.doe@domain.jor.br
    john.doe@domain.jus.br
    john.doe@domain.leg.br
    john.doe@domain.lel.br
    john.doe@domain.mat.br
    john.doe@domain.med.br
    john.doe@domain.mil.br
    john.doe@domain.mp.br
    john.doe@domain.mus.br
    john.doe@domain.net.br
    john.doe@domain.nom.br
    john.doe@domain.not.br
    john.doe@domain.ntr.br
    john.doe@domain.odo.br
    john.doe@domain.org.br
    john.doe@domain.ppg.br
    john.doe@domain.pro.br
    john.doe@domain.psc.br
    john.doe@domain.psi.br
    john.doe@domain.qsl.br
    john.doe@domain.radio.br
    john.doe@domain.rec.br
    john.doe@domain.slg.br
    john.doe@domain.srv.br
    john.doe@domain.taxi.br
    john.doe@domain.teo.br
    john.doe@domain.tmp.br
    john.doe@domain.trd.br
    john.doe@domain.tur.br
    john.doe@domain.tv.br
    john.doe@domain.vet.br
    john.doe@domain.vlog.br
    john.doe@domain.wiki.br
    john.doe@domain.zlg.br
  ).each do |kase|
    it "does not propose a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:valid)
    end
  end
end
