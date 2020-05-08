namespace EmailInquire.Validators
{
    public class CountryCodeTld : ValidatorBase<CountryCodeTld>
    {
        public override Response Validate()
        {
            foreach (var tld in CountryCodeTLDs)
            {
                var result = tld.Validate(Name, Domain);
                if (result.IsDefined) return result;
            }

            return Response.Undefined;
        }
    }
}