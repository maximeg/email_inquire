using System.Linq;

namespace EmailInquire.Validators
{
    public class UniqueDomainProvider : ValidatorBase<UniqueDomainProvider>
    {
        public override Response Validate()
        {
            if (UniqueDomainProviders.Contains(Domain)) return Response.Valid(Email);
            var domain = UniqueDomainProviders.FirstOrDefault(d => d.Split('.')[0].Equals(Domain.Split('.')[0]));
            return !string.IsNullOrEmpty(domain) ? Response.Hint(Name, domain) : Response.Undefined;
        }
    }
}