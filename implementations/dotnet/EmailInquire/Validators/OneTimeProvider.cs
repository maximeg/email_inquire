using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validation rejecting the one-time providers domains
    /// </summary>
    public class OneTimeProvider : ValidatorBase<OneTimeProvider>
    {
        public override Response Validate()
        {
            return OneTimeProviders?.Contains(Domain) ?? false ? Response.Invalid(Email) : Response.Undefined;
        }
    }
}