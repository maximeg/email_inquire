using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace EmailInquire.Validators
{
    /// <summary>
    ///     The base class of all validators. Contains all the domain verification collections
    /// </summary>
    public abstract class ValidatorBase
    {
        private const string TldLocation = "country_code_tld";

        protected static readonly IEnumerable<CountryCodeData> CountryCodeTLDs = new[]
        {
            new CountryCodeData("jp", "co"),
            new CountryCodeData("uk", "co"),
            new CountryCodeData("br", "com")
        };

        /// <summary>
        ///     List of common mistakes
        /// </summary>
        protected static readonly IEnumerable<(Regex, string)> CommonMistakes = new[]
        {
            // ReSharper disable StringLiteralTypo
            (new Regex(@"google(?!mail)"), @"gmail.com"),
            (new Regex(@"windows.*\.com"), @"live.com")
            // ReSharper restore StringLiteralTypo
        };

        /// <summary>
        ///     List of common TLD mistakes
        /// </summary>
        protected static readonly IEnumerable<(string, string)> CommonTLDMistakes = new[]
        {
            // ReSharper disable StringLiteralTypo
            (@".combr", @".com.br"),
            (@".cojp", @".co.jp"),
            (@".couk", @".co.uk"),
            (@".com.com", @".com")
            // ReSharper restore StringLiteralTypo
        };


        protected readonly Regex DomainPattern =
            new Regex(@"\A(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\Z");

        protected readonly Regex NamePattern =
            new Regex(@"\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*)\Z");

        protected IValidationContext ValidationContext { get; set; }
        protected string Email { get; set; }
        protected string Name { get; set; }
        protected string Domain { get; set; }

        /// <summary>
        ///     Custom list ov valid domains
        /// </summary>
        protected IEnumerable<string> ValidDomains { get; private set; }

        /// <summary>
        ///     Custom list of invalid domains
        /// </summary>
        protected IEnumerable<string> InvalidDomains { get; private set; }

        /// <summary>
        ///     Uploaded list of Common Providers
        /// </summary>
        protected static Lazy<IEnumerable<string>> CommonDomains { get; } = new Lazy<IEnumerable<string>>(
            LoadData(Path.Combine(EmailInquirer.DataLocation, "common_providers.txt")));

        /// <summary>
        ///     Uploaded list of Known Invalid Domains
        /// </summary>
        protected static Lazy<IEnumerable<string>> KnownInvalidDomains { get; } =
            new Lazy<IEnumerable<string>>(LoadData(Path.Combine(EmailInquirer.DataLocation, "known_invalid_domains.txt")));

        /// <summary>
        ///     Uploaded list of One-Time Providers
        /// </summary>
        protected static Lazy<IEnumerable<string>> OneTimeProviders { get; } =
            new Lazy<IEnumerable<string>>(LoadData(Path.Combine(EmailInquirer.DataLocation, "one_time_providers.txt")));

        /// <summary>
        /// Uploaded list of Unique domain Providers
        /// </summary>
        protected static Lazy<IEnumerable<string>> UniqueDomainProviders { get; } = new Lazy<IEnumerable<string>>(
            LoadData(Path.Combine(EmailInquirer.DataLocation, "unique_domain_providers.txt")));

        /// <summary>
        ///     Sets the list of custom valid domains
        /// </summary>
        /// <param name="domains">List of custom valid domains</param>
        public void SetValidDomains(IEnumerable<string> domains)
        {
            ValidDomains = domains;
        }

        /// <summary>
        ///     Sets the list of custom invalid domains
        /// </summary>
        /// <param name="domains">List of custom invalid domains</param>
        public void SetInvalidDomains(IEnumerable<string> domains)
        {
            InvalidDomains = domains;
        }

        /// <summary>
        ///     Easily load data from text files
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        private static IEnumerable<string> LoadData(string fileName)
        {
            if (!File.Exists(fileName))
            {
                throw new Exception($"Email Inquire Data file {fileName} doesn't exist");
            }

            return File.ReadAllLines(fileName).Where(l => !l.StartsWith('#'));
        }

        /// <summary>
        ///     Damerau-Levenshtein distance algorithm implementation
        /// </summary>
        /// <param name="original">the original string</param>
        /// <param name="modified">the modified string</param>
        /// <returns>distance of similarity (min quantity of necessary changes from one string to another)</returns>
        protected static int Distance(string original, string modified)
        {
            if (original == modified)
                return 0;

            var lenOrig = original.Length;
            var lenDiff = modified.Length;
            if (lenOrig == 0 || lenDiff == 0)
                return lenOrig == 0 ? lenDiff : lenOrig;

            var matrix = new int[lenOrig + 1, lenDiff + 1];

            for (var i = 1; i <= lenOrig; i++)
            {
                matrix[i, 0] = i;
                for (var j = 1; j <= lenDiff; j++)
                {
                    var cost = modified[j - 1] == original[i - 1] ? 0 : 1;
                    if (i == 1)
                        matrix[0, j] = j;

                    var values = new[]
                    {
                        matrix[i - 1, j] + 1,
                        matrix[i, j - 1] + 1,
                        matrix[i - 1, j - 1] + cost
                    };
                    matrix[i, j] = values.Min();
                    if (i > 1 && j > 1 && original[i - 1] == modified[j - 2] && original[i - 2] == modified[j - 1])
                        matrix[i, j] = Math.Min(matrix[i, j], matrix[i - 2, j - 2] + cost);
                }
            }

            return matrix[lenOrig, lenDiff];
        }

        protected class CountryCodeData
        {
            public CountryCodeData(string tld, string genericCom, bool regTldOnly = true)
            {
                CCTLD = tld;
                GenericCom = genericCom;
                RegTldOnly = regTldOnly;
                Generics = new Lazy<IEnumerable<string>>(LoadData(Path.Combine(EmailInquirer.DataLocation, TldLocation, $"{tld}.txt")));
            }

            // ReSharper disable once IdentifierTypo
            private string CCTLD { get; }
            private string GenericCom { get; }
            private Lazy<IEnumerable<string>> Generics { get; }
            private bool RegTldOnly { get; }

            public Response Validate(string name, string domain)
            {
                var split = domain.Split('.', StringSplitOptions.RemoveEmptyEntries);
                var tld = split[^1];
                var sld = split[^2];
                var rest = domain.Length > tld.Length + sld.Length + 2
                    ? domain.Substring(0, domain.Length - tld.Length - sld.Length - 2)
                    : string.Empty;
                string generic;
                if (!tld.Equals(CCTLD))
                {
                    generic = Generics.Value.FirstOrDefault(g => tld.Equals($"{g}{CCTLD}"));
                    return string.IsNullOrEmpty(generic)
                        ? Response.Undefined
                        : Response.Hint(name, $"{rest}.{sld}.{generic}.{CCTLD}");
                }

                if (Generics.Value.Contains(sld))
                    return string.IsNullOrEmpty(rest) ? Response.Invalid($"{name}@{domain}") : Response.Undefined;

                generic = Generics.Value.FirstOrDefault(g => sld.EndsWith(g));
                if (!string.IsNullOrEmpty(generic))
                    return Response.Hint(name, JoinNotNull('.', rest, sld.Replace(generic, ""), generic, CCTLD));
                var commonProvider = JoinNotNull('.', sld, GenericCom, CCTLD);
                if (CommonDomains.Value.Contains(commonProvider))
                    return Response.Hint(name, commonProvider);
                if (sld.Length < 3 || !RegTldOnly)
                    return Response.Hint(name, JoinNotNull('.', rest, sld.Length > 2 ? sld : null, GenericCom, CCTLD));
                return Response.Undefined;
            }

            private static string JoinNotNull(char separator, params string[] values)
            {
                return string.Join(separator, values.Where(v => !string.IsNullOrEmpty(v)));
            }
        }
    }

    /// <summary>
    ///     Generic base class of CRTP pattern. Used to provide universal static method <see cref="Validate(string)" /> for
    ///     common usage pattern
    /// </summary>
    /// <typeparam name="TChild">The type of derived type to construct the instance and use <see cref="Validate()" /> methods</typeparam>
    public abstract class ValidatorBase<TChild> : ValidatorBase, IValidator where TChild : ValidatorBase<TChild>, new()
    {
        public abstract Response Validate();

        public static Response Validate(string email, IValidationContext validationContext)
        {
            return Create(email, validationContext).Validate();
        }

        private static IValidator Create(string email, IValidationContext validationContext)
        {
            email = email?.ToLower();
            var parts = email?.Split('@');
            var name = parts?[0];
            var domain = (parts?.Length ?? 0) > 1 ? parts?[1] : null;
            return new TChild {ValidationContext = validationContext, Email = email, Name = name, Domain = domain};
        }
    }
}