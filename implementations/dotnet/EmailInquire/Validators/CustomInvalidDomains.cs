using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validator over list of custom invalid domains
    /// </summary>
    public class CustomInvalidDomains : ValidatorBase<CustomInvalidDomains>
    {
        public override Response Validate()
        {
            return ValidationContext?.CustomInvalidDomains?.Contains(Domain) ?? false
                ? Response.Invalid(Email)
                : Response.Undefined;
        }
    }
}