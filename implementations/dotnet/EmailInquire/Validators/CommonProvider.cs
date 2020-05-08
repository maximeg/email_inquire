using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validation over common provider list
    /// </summary>
    public class CommonProvider : ValidatorBase<CommonProvider>
    {
        public override Response Validate()
        {
            return CommonDomains?.Contains(Domain) ?? false ? Response.Valid(Email) : Response.Undefined;
        }
    }
}