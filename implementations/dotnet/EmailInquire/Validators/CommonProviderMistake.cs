using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validation with hint result over Damerau-Levenshtein algorithm and common domains list
    /// </summary>
    public class CommonProviderMistake : ValidatorBase<CommonProviderMistake>
    {
        public override Response Validate()
        {
            if (CommonDomains.Contains(Domain)) return Response.Undefined;
            var match = CommonDomains.FirstOrDefault(d => Distance(d, Domain) == 1);
            return match != null ? Response.Hint(Name, match) : Response.Undefined;
        }
    }
}