using System.Linq;

namespace EmailInquire.Validators
{
    public class UniqueDomainProvider : ValidatorBase<UniqueDomainProvider>
    {
        public override Response Validate()
        {
            if (UniqueDomainProviders.Value.Contains(Domain)) return Response.Valid(Email);
            var domain = UniqueDomainProviders.Value.FirstOrDefault(d => d.Split('.')[0].Equals(Domain.Split('.')[0]));
            return !string.IsNullOrEmpty(domain) ? Response.Hint(Name, domain) : Response.Undefined;
        }
    }
}