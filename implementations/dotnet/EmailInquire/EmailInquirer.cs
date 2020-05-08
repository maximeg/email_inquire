using System;
using System.Collections.Generic;
using EmailInquire.Validators;

namespace EmailInquire
{
    public class EmailInquirer
    {
        private readonly ValidationContext _validationContext = ValidationContext.DefaultContext;

        /// <summary>
        ///     The validators list in the order of validation
        /// </summary>
        private readonly IEnumerable<Func<string, IValidationContext, Response>> _validators =
            new Func<string, IValidationContext, Response>[]
            {
                //Format first
                EmailFormat.Validate,
                //Custom overrides
                CustomValidDomains.Validate,
                CustomInvalidDomains.Validate,
                //Always valid domains
                CommonProvider.Validate,
                //Invalid domains
                KnownInvalidDomain.Validate,
                OneTimeProvider.Validate,
                //Hints
                CommonProviderMistake.Validate,
                CommonlyMistakenDomain.Validate,
                CommonlyMistakenTld.Validate,
                CountryCodeTld.Validate,
                UniqueDomainProvider.Validate
            };

        /// <summary>
        ///     Method to set custom invalid domains
        /// </summary>
        /// <param name="domains">params custom list of domains to be marked as invalid</param>
        public void SetInvalidDomains(params string[] domains)
        {
            _validationContext.CustomInvalidDomains = domains;
        }

        /// <summary>
        ///     Methods to set custom valid domains
        /// </summary>
        /// <param name="domains">params custom list of domains to be marked as valid</param>
        public void SetValidDomains(params string[] domains)
        {
            _validationContext.CustomValidDomains = domains;
        }

        /// <summary>
        ///     Validates the email using the list of validators
        /// </summary>
        /// <param name="email">The email address to validate on input</param>
        /// <returns>Response object which contains validation result and recommended replacement</returns>
        public Response Validate(string email)
        {
            // loop through validators until validation result defined
            foreach (var validator in _validators)
            {
                var response = validator.Invoke(email, _validationContext);
                if (response.IsDefined) return response;
            }

            // if validation rules for address not specified mark address as valid
            return Response.Valid(email);
        }
    }
}