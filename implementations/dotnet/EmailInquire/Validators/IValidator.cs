using System.Collections.Generic;

namespace EmailInquire.Validators
{
    public interface IValidator
    {
        Response Validate();
    }
}