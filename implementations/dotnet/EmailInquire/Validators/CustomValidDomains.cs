using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validation over list of custom valid domains
    /// </summary>
    public class CustomValidDomains : ValidatorBase<CustomValidDomains>
    {
        public override Response Validate()
        {
            return ValidationContext?.CustomValidDomains?.Contains(Domain) ?? false
                ? Response.Valid(Email)
                : Response.Undefined;
        }
    }
}