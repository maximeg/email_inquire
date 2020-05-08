using System.Linq;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     Validation to hint the common mistaken domains recommendation
    /// </summary>
    public class CommonlyMistakenDomain : ValidatorBase<CommonlyMistakenDomain>
    {
        public override Response Validate()
        {
            if (CommonMistakes.Any(i => i.Item2.Equals(Domain))) return Response.Valid(Email);
            var match = CommonMistakes.FirstOrDefault(m => m.Item1.IsMatch(Domain));
            return match.Equals(default)
                ? Response.Undefined
                : Response.Hint(Name, match.Item2);
        }
    }
}