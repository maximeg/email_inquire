using System.Collections.Generic;

namespace EmailInquire
{
    public class ValidationContext: IValidationContext
    {
        public static ValidationContext DefaultContext => new ValidationContext();
        
        public IEnumerable<string> CustomValidDomains { get; set; } = new List<string>();
        public IEnumerable<string> CustomInvalidDomains { get; set; } = new List<string>();
    }

    public interface IValidationContext
    {
        IEnumerable<string> CustomValidDomains { get; }
        IEnumerable<string> CustomInvalidDomains { get; }
    }
}