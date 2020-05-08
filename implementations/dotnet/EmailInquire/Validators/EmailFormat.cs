namespace EmailInquire.Validators
{
    /// <summary>
    ///     Email format validator
    /// </summary>
    public class EmailFormat : ValidatorBase<EmailFormat>
    {
        public override Response Validate()
        {
            return string.IsNullOrWhiteSpace(Email) || Email.Length > 255 || !DomainPattern.IsMatch(Domain??"") ||
                   !NamePattern.IsMatch(Name??"")
                ? Response.Invalid(Email)
                : Response.Undefined;
        }
    }
}