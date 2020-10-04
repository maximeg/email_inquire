using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validation over known invalid domains list
    /// </summary>
    public class KnownInvalidDomain : ValidatorBase<KnownInvalidDomain>
    {
        public override Response Validate()
        {
            return KnownInvalidDomains?.Value.Contains(Domain) ?? false ? Response.Invalid(Email) : Response.Undefined;
        }
    }
}