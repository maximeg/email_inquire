using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validation of a split spelling of common TLD
    /// </summary>
    public class CommonlyMistakenTld : ValidatorBase<CommonlyMistakenTld>
    {
        public override Response Validate()
        {
            var match = CommonTLDMistakes.FirstOrDefault(h => Domain.EndsWith(h.Item1));
            return match.Equals(default)
                ? Response.Undefined
                : Response.Hint(Name, Domain.Replace(match.Item1, match.Item2));
        }
    }
}