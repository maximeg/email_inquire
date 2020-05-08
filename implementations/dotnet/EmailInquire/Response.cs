namespace EmailInquire
{
    /// <summary>
    ///     Response wrapper class contains validation flags and recommended email for any validation result
    /// </summary>
    public class Response
    {
        private Response(string email)
        {
            Email = email;
        }

        /// <summary>
        ///     Recommended or verified email
        /// </summary>
        public string Email { get; }

        /// <summary>
        ///     Response status
        /// </summary>
        private ResponseStatus Status { get; set; } = ResponseStatus.Undefined;

        /// <summary>
        ///     Constructed undefined response
        /// </summary>
        public static Response Undefined => new Response("") {Status = ResponseStatus.Undefined};


        public bool IsHint => Status.Equals(ResponseStatus.Hint);

        public bool IsInvalid => Status.Equals(ResponseStatus.Invalid);

        public bool IsValid => Status.Equals(ResponseStatus.Valid);

        public bool IsDefined => !Status.Equals(ResponseStatus.Undefined);

        /// <summary>
        ///     Constructs <see cref="Invalid" /> response result
        /// </summary>
        /// <param name="email">The email to be contained in result</param>
        /// <returns>Response with Invalid status and original email</returns>
        public static Response Invalid(string email)
        {
            return new Response(email) {Status = ResponseStatus.Invalid};
        }

        /// <summary>
        ///     Constructs <see cref="Valid" /> response result
        /// </summary>
        /// <param name="email">The email to be contained in result</param>
        /// <returns>Response with Valid status and original email</returns>
        public static Response Valid(string email)
        {
            return new Response(email) {Status = ResponseStatus.Valid};
        }

        /// <summary>
        ///     Constructs <see cref="Hint" /> response result
        /// </summary>
        /// <param name="name">The name part of email to be contained in result</param>
        /// <param name="domain">The domain part of email to be contained in result</param>
        /// <returns>Response with Valid status and recommended email</returns>
        public static Response Hint(string name, string domain)
        {
            return new Response($"{name}@{domain}") {Status = ResponseStatus.Hint};
        }
    }
}