/* a simple 'easy-interface' libcurl wrapper for the D 2.0 programming
   language. Mostly a learning exercise, but it works. */

module fawcett.curl;

pragma(lib, "curl");

import std.stdio;
import std.string;
import std.conv;
import std.regex;

alias void CURL;

enum CURLcode {
  CURLE_OK = 0,
  CURLE_UNSUPPORTED_PROTOCOL,    /* 1 */
  CURLE_FAILED_INIT,             /* 2 */
  CURLE_URL_MALFORMAT,           /* 3 */
  CURLE_OBSOLETE4,               /* 4 - NOT USED */
  CURLE_COULDNT_RESOLVE_PROXY,   /* 5 */
  CURLE_COULDNT_RESOLVE_HOST,    /* 6 */
  CURLE_COULDNT_CONNECT,         /* 7 */
  CURLE_FTP_WEIRD_SERVER_REPLY,  /* 8 */
  CURLE_REMOTE_ACCESS_DENIED,    /* 9 a service was denied by the server
                                    due to lack of access - when login fails
                                    this is not returned. */
  CURLE_OBSOLETE10,              /* 10 - NOT USED */
  CURLE_FTP_WEIRD_PASS_REPLY,    /* 11 */
  CURLE_OBSOLETE12,              /* 12 - NOT USED */
  CURLE_FTP_WEIRD_PASV_REPLY,    /* 13 */
  CURLE_FTP_WEIRD_227_FORMAT,    /* 14 */
  CURLE_FTP_CANT_GET_HOST,       /* 15 */
  CURLE_OBSOLETE16,              /* 16 - NOT USED */
  CURLE_FTP_COULDNT_SET_TYPE,    /* 17 */
  CURLE_PARTIAL_FILE,            /* 18 */
  CURLE_FTP_COULDNT_RETR_FILE,   /* 19 */
  CURLE_OBSOLETE20,              /* 20 - NOT USED */
  CURLE_QUOTE_ERROR,             /* 21 - quote command failure */
  CURLE_HTTP_RETURNED_ERROR,     /* 22 */
  CURLE_WRITE_ERROR,             /* 23 */
  CURLE_OBSOLETE24,              /* 24 - NOT USED */
  CURLE_UPLOAD_FAILED,           /* 25 - failed upload "command" */
  CURLE_READ_ERROR,              /* 26 - couldn't open/read from file */
  CURLE_OUT_OF_MEMORY,           /* 27 */
  /* Note: CURLE_OUT_OF_MEMORY may sometimes indicate a conversion error
           instead of a memory allocation error if CURL_DOES_CONVERSIONS
           is defined
  */
  CURLE_OPERATION_TIMEDOUT,      /* 28 - the timeout time was reached */
  CURLE_OBSOLETE29,              /* 29 - NOT USED */
  CURLE_FTP_PORT_FAILED,         /* 30 - FTP PORT operation failed */
  CURLE_FTP_COULDNT_USE_REST,    /* 31 - the REST command failed */
  CURLE_OBSOLETE32,              /* 32 - NOT USED */
  CURLE_RANGE_ERROR,             /* 33 - RANGE "command" didn't work */
  CURLE_HTTP_POST_ERROR,         /* 34 */
  CURLE_SSL_CONNECT_ERROR,       /* 35 - wrong when connecting with SSL */
  CURLE_BAD_DOWNLOAD_RESUME,     /* 36 - couldn't resume download */
  CURLE_FILE_COULDNT_READ_FILE,  /* 37 */
  CURLE_LDAP_CANNOT_BIND,        /* 38 */
  CURLE_LDAP_SEARCH_FAILED,      /* 39 */
  CURLE_OBSOLETE40,              /* 40 - NOT USED */
  CURLE_FUNCTION_NOT_FOUND,      /* 41 */
  CURLE_ABORTED_BY_CALLBACK,     /* 42 */
  CURLE_BAD_FUNCTION_ARGUMENT,   /* 43 */
  CURLE_OBSOLETE44,              /* 44 - NOT USED */
  CURLE_INTERFACE_FAILED,        /* 45 - CURLOPT_INTERFACE failed */
  CURLE_OBSOLETE46,              /* 46 - NOT USED */
  CURLE_TOO_MANY_REDIRECTS ,     /* 47 - catch endless re-direct loops */
  CURLE_UNKNOWN_TELNET_OPTION,   /* 48 - User specified an unknown option */
  CURLE_TELNET_OPTION_SYNTAX ,   /* 49 - Malformed telnet option */
  CURLE_OBSOLETE50,              /* 50 - NOT USED */
  CURLE_PEER_FAILED_VERIFICATION, /* 51 - peer's certificate or fingerprint
                                     wasn't verified fine */
  CURLE_GOT_NOTHING,             /* 52 - when this is a specific error */
  CURLE_SSL_ENGINE_NOTFOUND,     /* 53 - SSL crypto engine not found */
  CURLE_SSL_ENGINE_SETFAILED,    /* 54 - can not set SSL crypto engine as
                                    default */
  CURLE_SEND_ERROR,              /* 55 - failed sending network data */
  CURLE_RECV_ERROR,              /* 56 - failure in receiving network data */
  CURLE_OBSOLETE57,              /* 57 - NOT IN USE */
  CURLE_SSL_CERTPROBLEM,         /* 58 - problem with the local certificate */
  CURLE_SSL_CIPHER,              /* 59 - couldn't use specified cipher */
  CURLE_SSL_CACERT,              /* 60 - problem with the CA cert (path?) */
  CURLE_BAD_CONTENT_ENCODING,    /* 61 - Unrecognized transfer encoding */
  CURLE_LDAP_INVALID_URL,        /* 62 - Invalid LDAP URL */
  CURLE_FILESIZE_EXCEEDED,       /* 63 - Maximum file size exceeded */
  CURLE_USE_SSL_FAILED,          /* 64 - Requested FTP SSL level failed */
  CURLE_SEND_FAIL_REWIND,        /* 65 - Sending the data requires a rewind
                                    that failed */
  CURLE_SSL_ENGINE_INITFAILED,   /* 66 - failed to initialise ENGINE */
  CURLE_LOGIN_DENIED,            /* 67 - user, password or similar was not
                                    accepted and we failed to login */
  CURLE_TFTP_NOTFOUND,           /* 68 - file not found on server */
  CURLE_TFTP_PERM,               /* 69 - permission problem on server */
  CURLE_REMOTE_DISK_FULL,        /* 70 - out of disk space on server */
  CURLE_TFTP_ILLEGAL,            /* 71 - Illegal TFTP operation */
  CURLE_TFTP_UNKNOWNID,          /* 72 - Unknown transfer ID */
  CURLE_REMOTE_FILE_EXISTS,      /* 73 - File already exists */
  CURLE_TFTP_NOSUCHUSER,         /* 74 - No such user */
  CURLE_CONV_FAILED,             /* 75 - conversion failed */
  CURLE_CONV_REQD,               /* 76 - caller must register conversion
                                    callbacks using curl_easy_setopt options
                                    CURLOPT_CONV_FROM_NETWORK_FUNCTION,
                                    CURLOPT_CONV_TO_NETWORK_FUNCTION, and
                                    CURLOPT_CONV_FROM_UTF8_FUNCTION */
  CURLE_SSL_CACERT_BADFILE,      /* 77 - could not load CACERT file, missing
                                    or wrong format */
  CURLE_REMOTE_FILE_NOT_FOUND,   /* 78 - remote file not found */
  CURLE_SSH,                     /* 79 - error from the SSH layer, somewhat
                                    generic so the error message will be of
                                    interest when this has happened */

  CURLE_SSL_SHUTDOWN_FAILED,     /* 80 - Failed to shut down the SSL
                                    connection */
  CURLE_AGAIN,                   /* 81 - socket is not ready for send/recv,
                                    wait till it's ready and try again (Added
                                    in 7.18.2) */
  CURLE_SSL_CRL_BADFILE,         /* 82 - could not load CRL file, missing or
                                    wrong format (Added in 7.19.0) */
  CURLE_SSL_ISSUER_ERROR,        /* 83 - Issuer check failed.  (Added in
                                    7.19.0) */
  CURL_LAST /* never use! */
};

const CURLOPTTYPE_LONG          = 0;
const CURLOPTTYPE_OBJECTPOINT   = 10000;
const CURLOPTTYPE_FUNCTIONPOINT = 20000;
const CURLOPTTYPE_OFF_T         = 30000;

enum CURLoption {
  /* This is the FILE * or void * the regular output should be written to. */
  FILE = CURLOPTTYPE_OBJECTPOINT + 1,

  /* The full URL to get/put */
  URL = CURLOPTTYPE_OBJECTPOINT + 2,

  /* Port number to connect to, if other than default. */
  PORT = CURLOPTTYPE_LONG + 3,

  /* Name of proxy to use. */
  PROXY = CURLOPTTYPE_OBJECTPOINT + 4,

  /* "name:password" to use when fetching. */
  USERPWD = CURLOPTTYPE_OBJECTPOINT + 5,

  /* "name:password" to use with proxy. */
  PROXYUSERPWD = CURLOPTTYPE_OBJECTPOINT + 6,

  /* Range to get, specified as an ASCII string. */
  RANGE = CURLOPTTYPE_OBJECTPOINT + 7,

  /* not used */

  /* Specified file stream to upload from (use as input): */
  INFILE = CURLOPTTYPE_OBJECTPOINT + 9,

  /* Buffer to receive error messages in, must be at least CURL_ERROR_SIZE
   * bytes big. If this is not used, error messages go to stderr instead: */
  ERRORBUFFER = CURLOPTTYPE_OBJECTPOINT + 10,

  /* Function that will be called to store the output (instead of fwrite). The
   * parameters will use fwrite() syntax, make sure to follow them. */
  WRITEFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 11,

  /* Function that will be called to read the input (instead of fread). The
   * parameters will use fread() syntax, make sure to follow them. */
  READFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 12,

  /* Time-out the read operation after this amount of seconds */
  TIMEOUT = CURLOPTTYPE_LONG + 13,

  /* If the INFILE is used, this can be used to inform libcurl about
   * how large the file being sent really is. That allows better error
   * checking and better verifies that the upload was successful. -1 means
   * unknown size.
   *
   * For large file support, there is also a _LARGE version of the key
   * which takes an off_t type, allowing platforms with larger off_t
   * sizes to handle larger files.  See below for INFILESIZE_LARGE.
   */
  INFILESIZE = CURLOPTTYPE_LONG + 14,

  /* POST static input fields. */
  POSTFIELDS = CURLOPTTYPE_OBJECTPOINT + 15,

  /* Set the referrer page (needed by some CGIs) */
  REFERER = CURLOPTTYPE_OBJECTPOINT + 16,

  /* Set the FTP PORT string (interface name, named or numerical IP address)
     Use i.e '-' to use default address. */
  FTPPORT = CURLOPTTYPE_OBJECTPOINT + 17,

  /* Set the User-Agent string (examined by some CGIs) */
  USERAGENT = CURLOPTTYPE_OBJECTPOINT + 18,

  /* If the download receives less than "low speed limit" bytes/second
   * during "low speed time" seconds, the operations is aborted.
   * You could i.e if you have a pretty high speed connection, abort if
   * it is less than 2000 bytes/sec during 20 seconds.
   */

  /* Set the "low speed limit" */
  LOW_SPEED_LIMIT = CURLOPTTYPE_LONG + 19,

  /* Set the "low speed time" */
  LOW_SPEED_TIME = CURLOPTTYPE_LONG + 20,

  /* Set the continuation offset.
   *
   * Note there is also a _LARGE version of this key which uses
   * off_t types, allowing for large file offsets on platforms which
   * use larger-than-32-bit off_t's.  Look below for RESUME_FROM_LARGE.
   */
  RESUME_FROM = CURLOPTTYPE_LONG + 21,

  /* Set cookie in request: */
  COOKIE = CURLOPTTYPE_OBJECTPOINT + 22,

  /* This points to a linked list of headers, struct curl_slist kind */
  HTTPHEADER = CURLOPTTYPE_OBJECTPOINT + 23,

  /* This points to a linked list of post entries, struct curl_httppost */
  HTTPPOST = CURLOPTTYPE_OBJECTPOINT + 24,

  /* name of the file keeping your private SSL-certificate */
  SSLCERT = CURLOPTTYPE_OBJECTPOINT + 25,

  /* password for the SSL or SSH private key */
  KEYPASSWD = CURLOPTTYPE_OBJECTPOINT + 26,

  /* send TYPE parameter? */
  CRLF = CURLOPTTYPE_LONG + 27,

  /* send linked-list of QUOTE commands */
  QUOTE = CURLOPTTYPE_OBJECTPOINT + 28,

  /* send FILE * or void * to store headers to, if you use a callback it
     is simply passed to the callback unmodified */
  WRITEHEADER = CURLOPTTYPE_OBJECTPOINT + 29,

  /* point to a file to read the initial cookies from, also enables
     "cookie awareness" */
  COOKIEFILE = CURLOPTTYPE_OBJECTPOINT + 31,

  /* What version to specifically try to use.
     See CURL_SSLVERSION defines below. */
  SSLVERSION = CURLOPTTYPE_LONG + 32,

  /* What kind of HTTP time condition to use, see defines */
  TIMECONDITION = CURLOPTTYPE_LONG + 33,

  /* Time to use with the above condition. Specified in number of seconds
     since 1 Jan 1970 */
  TIMEVALUE = CURLOPTTYPE_LONG + 34,

  /* 35 = OBSOLETE */

  /* Custom request, for customizing the get command like
     HTTP: DELETE, TRACE and others
     FTP: to use a different list command
     */
  CUSTOMREQUEST = CURLOPTTYPE_OBJECTPOINT + 36,

  /* HTTP request, for odd commands like DELETE, TRACE and others */
  STDERR = CURLOPTTYPE_OBJECTPOINT + 37,

  /* 38 is not used */

  /* send linked-list of post-transfer QUOTE commands */
  POSTQUOTE = CURLOPTTYPE_OBJECTPOINT + 39,

  /* Pass a pointer to string of the output using full variable-replacement
     as described elsewhere. */
  WRITEINFO = CURLOPTTYPE_OBJECTPOINT + 40,

  VERBOSE = CURLOPTTYPE_LONG + 41,
  HEADER = CURLOPTTYPE_LONG + 42,
  NOPROGRESS = CURLOPTTYPE_LONG + 43,
  NOBODY = CURLOPTTYPE_LONG + 44,
  FAILONERROR = CURLOPTTYPE_LONG + 45,
  UPLOAD = CURLOPTTYPE_LONG + 46,
  POST = CURLOPTTYPE_LONG + 47,
  DIRLISTONLY = CURLOPTTYPE_LONG + 48,

  APPEND = CURLOPTTYPE_LONG + 50,

  /* Specify whether to read the user+password from the .netrc or the URL.
   * This must be one of the CURL_NETRC_* enums below. */
  NETRC = CURLOPTTYPE_LONG + 51,

  FOLLOWLOCATION = CURLOPTTYPE_LONG + 52,

  TRANSFERTEXT = CURLOPTTYPE_LONG + 53,
  PUT = CURLOPTTYPE_LONG + 54,

  /* 55 = OBSOLETE */

  /* Function that will be called instead of the internal progress display
   * function. This function should be defined as the curl_progress_callback
   * prototype defines. */
  PROGRESSFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 56,

  /* Data passed to the progress callback */
  PROGRESSDATA = CURLOPTTYPE_OBJECTPOINT + 57,

  /* We want the referrer field set automatically when following locations */
  AUTOREFERER = CURLOPTTYPE_LONG + 58,

  /* Port of the proxy, can be set in the proxy string as well with:
     "[host]:[port]" */
  PROXYPORT = CURLOPTTYPE_LONG + 59,

  /* size of the POST input data, if strlen() is not good to use */
  POSTFIELDSIZE = CURLOPTTYPE_LONG + 60,

  /* tunnel non-http operations through a HTTP proxy */
  HTTPPROXYTUNNEL = CURLOPTTYPE_LONG + 61,

  /* Set the interface string to use as outgoing network interface */
  INTERFACE = CURLOPTTYPE_OBJECTPOINT + 62,

  /* Set the krb4/5 security level, this also enables krb4/5 awareness.  This
   * is a string, 'clear', 'safe', 'confidential' or 'private'.  If the string
   * is set but doesn't match one of these, 'private' will be used.  */
  KRBLEVEL = CURLOPTTYPE_OBJECTPOINT + 63,

  /* Set if we should verify the peer in ssl handshake, set 1 to verify. */
  SSL_VERIFYPEER = CURLOPTTYPE_LONG + 64,

  /* The CApath or CAfile used to validate the peer certificate
     this option is used only if SSL_VERIFYPEER is true */
  CAINFO = CURLOPTTYPE_OBJECTPOINT + 65,

  /* 66 = OBSOLETE */
  /* 67 = OBSOLETE */

  /* Maximum number of http redirects to follow */
  MAXREDIRS = CURLOPTTYPE_LONG + 68,

  /* Pass a long set to 1 to get the date of the requested document (if
     possible)! Pass a zero to shut it off. */
  FILETIME = CURLOPTTYPE_LONG + 69,

  /* This points to a linked list of telnet options */
  TELNETOPTIONS = CURLOPTTYPE_OBJECTPOINT + 70,

  /* Max amount of cached alive connections */
  MAXCONNECTS = CURLOPTTYPE_LONG + 71,

  /* What policy to use when closing connections when the cache is filled
     up */
  CLOSEPOLICY = CURLOPTTYPE_LONG + 72,

  /* 73 = OBSOLETE */

  /* Set to explicitly use a new connection for the upcoming transfer.
     Do not use this unless you're absolutely sure of this, as it makes the
     operation slower and is less friendly for the network. */
  FRESH_CONNECT = CURLOPTTYPE_LONG + 74,

  /* Set to explicitly forbid the upcoming transfer's connection to be re-used
     when done. Do not use this unless you're absolutely sure of this, as it
     makes the operation slower and is less friendly for the network. */
  FORBID_REUSE = CURLOPTTYPE_LONG + 75,

  /* Set to a file name that contains random data for libcurl to use to
     seed the random engine when doing SSL connects. */
  RANDOM_FILE = CURLOPTTYPE_OBJECTPOINT + 76,

  /* Set to the Entropy Gathering Daemon socket pathname */
  EGDSOCKET = CURLOPTTYPE_OBJECTPOINT + 77,

  /* Time-out connect operations after this amount of seconds, if connects
     are OK within this time, then fine... This only aborts the connect
     phase. [Only works on unix-style/SIGALRM operating systems] */
  CONNECTTIMEOUT = CURLOPTTYPE_LONG + 78,

  /* Function that will be called to store headers (instead of fwrite). The
   * parameters will use fwrite() syntax, make sure to follow them. */
  HEADERFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 79,

  /* Set this to force the HTTP request to get back to GET. Only really usable
     if POST, PUT or a custom request have been used first.
   */
  HTTPGET = CURLOPTTYPE_LONG + 80,

  /* Set if we should verify the Common name from the peer certificate in ssl
   * handshake, set 1 to check existence, 2 to ensure that it matches the
   * provided hostname. */
  SSL_VERIFYHOST = CURLOPTTYPE_LONG + 81,

  /* Specify which file name to write all known cookies in after completed
     operation. Set file name to "-" (dash) to make it go to stdout. */
  COOKIEJAR = CURLOPTTYPE_OBJECTPOINT + 82,

  /* Specify which SSL ciphers to use */
  SSL_CIPHER_LIST = CURLOPTTYPE_OBJECTPOINT + 83,

  /* Specify which HTTP version to use! This must be set to one of the
     CURL_HTTP_VERSION* enums set below. */
  HTTP_VERSION = CURLOPTTYPE_LONG + 84,

  /* Specifically switch on or off the FTP engine's use of the EPSV command. By
     default, that one will always be attempted before the more traditional
     PASV command. */
  FTP_USE_EPSV = CURLOPTTYPE_LONG + 85,

  /* type of the file keeping your SSL-certificate ("DER", "PEM", "ENG") */
  SSLCERTTYPE = CURLOPTTYPE_OBJECTPOINT + 86,

  /* name of the file keeping your private SSL-key */
  SSLKEY = CURLOPTTYPE_OBJECTPOINT + 87,

  /* type of the file keeping your private SSL-key ("DER", "PEM", "ENG") */
  SSLKEYTYPE = CURLOPTTYPE_OBJECTPOINT + 88,

  /* crypto engine for the SSL-sub system */
  SSLENGINE = CURLOPTTYPE_OBJECTPOINT + 89,

  /* set the crypto engine for the SSL-sub system as default
     the param has no meaning...
   */
  SSLENGINE_DEFAULT = CURLOPTTYPE_LONG + 90,

  /* Non-zero value means to use the global dns cache */
  DNS_USE_GLOBAL_CACHE = CURLOPTTYPE_LONG + 91,

  /* DNS cache timeout */
  DNS_CACHE_TIMEOUT = CURLOPTTYPE_LONG + 92,

  /* send linked-list of pre-transfer QUOTE commands */
  PREQUOTE = CURLOPTTYPE_OBJECTPOINT + 93,

  /* set the debug function */
  DEBUGFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 94,

  /* set the data for the debug function */
  DEBUGDATA = CURLOPTTYPE_OBJECTPOINT + 95,

  /* mark this as start of a cookie session */
  COOKIESESSION = CURLOPTTYPE_LONG + 96,

  /* The CApath directory used to validate the peer certificate
     this option is used only if SSL_VERIFYPEER is true */
  CAPATH = CURLOPTTYPE_OBJECTPOINT + 97,

  /* Instruct libcurl to use a smaller receive buffer */
  BUFFERSIZE = CURLOPTTYPE_LONG + 98,

  /* Instruct libcurl to not use any signal/alarm handlers, even when using
     timeouts. This option is useful for multi-threaded applications.
     See libcurl-the-guide for more background information. */
  NOSIGNAL = CURLOPTTYPE_LONG + 99,

  /* Provide a CURLShare for mutexing non-ts data */
  SHARE = CURLOPTTYPE_OBJECTPOINT + 100,

  /* indicates type of proxy. accepted values are CURLPROXY_HTTP (default),
     CURLPROXY_SOCKS4, CURLPROXY_SOCKS4A and CURLPROXY_SOCKS5. */
  PROXYTYPE = CURLOPTTYPE_LONG + 101,

  /* Set the Accept-Encoding string. Use this to tell a server you would like
     the response to be compressed. */
  ENCODING = CURLOPTTYPE_OBJECTPOINT + 102,

  /* Set pointer to private data */
  PRIVATE = CURLOPTTYPE_OBJECTPOINT + 103,

  /* Set aliases for HTTP 200 in the HTTP Response header */
  HTTP200ALIASES = CURLOPTTYPE_OBJECTPOINT + 104,

  /* Continue to send authentication (user+password) when following locations,
     even when hostname changed. This can potentially send off the name
     and password to whatever host the server decides. */
  UNRESTRICTED_AUTH = CURLOPTTYPE_LONG + 105,

  /* Specifically switch on or off the FTP engine's use of the EPRT command ( it
     also disables the LPRT attempt). By default, those ones will always be
     attempted before the good old traditional PORT command. */
  FTP_USE_EPRT = CURLOPTTYPE_LONG + 106,

  /* Set this to a bitmask value to enable the particular authentications
     methods you like. Use this in combination with USERPWD.
     Note that setting multiple bits may cause extra network round-trips. */
  HTTPAUTH = CURLOPTTYPE_LONG + 107,

  /* Set the ssl context callback function, currently only for OpenSSL ssl_ctx
     in second argument. The function must be matching the
     curl_ssl_ctx_callback proto. */
  SSL_CTX_FUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 108,

  /* Set the userdata for the ssl context callback function's third
     argument */
  SSL_CTX_DATA = CURLOPTTYPE_OBJECTPOINT + 109,

  /* FTP Option that causes missing dirs to be created on the remote server.
     In 7.19.4 we introduced the convenience enums for this option using the
     CURLFTP_CREATE_DIR prefix.
  */
  FTP_CREATE_MISSING_DIRS = CURLOPTTYPE_LONG + 110,

  /* Set this to a bitmask value to enable the particular authentications
     methods you like. Use this in combination with PROXYUSERPWD.
     Note that setting multiple bits may cause extra network round-trips. */
  PROXYAUTH = CURLOPTTYPE_LONG + 111,

  /* FTP option that changes the timeout, in seconds, associated with
     getting a response.  This is different from transfer timeout time and
     essentially places a demand on the FTP server to acknowledge commands
     in a timely manner. */
  FTP_RESPONSE_TIMEOUT = CURLOPTTYPE_LONG + 112,

  /* Set this option to one of the CURL_IPRESOLVE_* defines (see below) to
     tell libcurl to resolve names to those IP versions only. This only has
     affect on systems with support for more than one, i.e IPv4 _and_ IPv6. */
  IPRESOLVE = CURLOPTTYPE_LONG + 113,

  /* Set this option to limit the size of a file that will be downloaded from
     an HTTP or FTP server.

     Note there is also _LARGE version which adds large file support for
     platforms which have larger off_t sizes.  See MAXFILESIZE_LARGE below. */
  MAXFILESIZE = CURLOPTTYPE_LONG + 114,

  /* See the comment for INFILESIZE above, but in short, specifies
   * the size of the file being uploaded.  -1 means unknown.
   */
  INFILESIZE_LARGE = CURLOPTTYPE_OFF_T + 115,

  /* Sets the continuation offset.  There is also a LONG version of this,
   * look above for RESUME_FROM.
   */
  RESUME_FROM_LARGE = CURLOPTTYPE_OFF_T + 116,

  /* Sets the maximum size of data that will be downloaded from
   * an HTTP or FTP server.  See MAXFILESIZE above for the LONG version.
   */
  MAXFILESIZE_LARGE = CURLOPTTYPE_OFF_T + 117,

  /* Set this option to the file name of your .netrc file you want libcurl
     to parse (using the NETRC option). If not set, libcurl will do
     a poor attempt to find the user's home directory and check for a .netrc
     file in there. */
  NETRC_FILE = CURLOPTTYPE_OBJECTPOINT + 118,

  /* Enable SSL/TLS for FTP, pick one of:
     CURLFTPSSL_TRY     - try using SSL, proceed anyway otherwise
     CURLFTPSSL_CONTROL - SSL for the control connection or fail
     CURLFTPSSL_ALL     - SSL for all communication or fail
  */
  USE_SSL = CURLOPTTYPE_LONG + 119,

  /* The _LARGE version of the standard POSTFIELDSIZE option */
  POSTFIELDSIZE_LARGE = CURLOPTTYPE_OFF_T + 120,

  /* Enable/disable the TCP Nagle algorithm */
  TCP_NODELAY = CURLOPTTYPE_LONG + 121,

  /* 122 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 123 OBSOLETE. Gone in 7.16.0 */
  /* 124 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 125 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 126 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
  /* 127 OBSOLETE. Gone in 7.16.0 */
  /* 128 OBSOLETE. Gone in 7.16.0 */

  /* When FTP over SSL/TLS is selected (with USE_SSL), this option
     can be used to change libcurl's default action which is to first try
     "AUTH SSL" and then "AUTH TLS" in this order, and proceed when a OK
     response has been received.

     Available parameters are:
     CURLFTPAUTH_DEFAULT - let libcurl decide
     CURLFTPAUTH_SSL     - try "AUTH SSL" first, then TLS
     CURLFTPAUTH_TLS     - try "AUTH TLS" first, then SSL
  */
  FTPSSLAUTH = CURLOPTTYPE_LONG + 129,

  IOCTLFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 130,
  IOCTLDATA = CURLOPTTYPE_OBJECTPOINT + 131,

  /* 132 OBSOLETE. Gone in 7.16.0 */
  /* 133 OBSOLETE. Gone in 7.16.0 */

  /* zero terminated string for pass on to the FTP server when asked for
     "account" info */
  FTP_ACCOUNT = CURLOPTTYPE_OBJECTPOINT + 134,

  /* feed cookies into cookie engine */
  COOKIELIST = CURLOPTTYPE_OBJECTPOINT + 135,

  /* ignore Content-Length */
  IGNORE_CONTENT_LENGTH = CURLOPTTYPE_LONG + 136,

  /* Set to non-zero to skip the IP address received in a 227 PASV FTP server
     response. Typically used for FTP-SSL purposes but is not restricted to
     that. libcurl will then instead use the same IP address it used for the
     control connection. */
  FTP_SKIP_PASV_IP = CURLOPTTYPE_LONG + 137,

  /* Select "file method" to use when doing FTP, see the curl_ftpmethod
     above. */
  FTP_FILEMETHOD = CURLOPTTYPE_LONG + 138,

  /* Local port number to bind the socket to */
  LOCALPORT = CURLOPTTYPE_LONG + 139,

  /* Number of ports to try, including the first one set with LOCALPORT.
     Thus, setting it to 1 will make no additional attempts but the first.
  */
  LOCALPORTRANGE = CURLOPTTYPE_LONG + 140,

  /* no transfer, set up connection and let application use the socket by
     extracting it with CURLINFO_LASTSOCKET */
  CONNECT_ONLY = CURLOPTTYPE_LONG + 141,

  /* Function that will be called to convert from the
     network encoding (instead of using the iconv calls in libcurl) */
  CONV_FROM_NETWORK_FUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 142,

  /* Function that will be called to convert to the
     network encoding (instead of using the iconv calls in libcurl) */
  CONV_TO_NETWORK_FUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 143,

  /* Function that will be called to convert from UTF8
     (instead of using the iconv calls in libcurl)
     Note that this is used only for SSL certificate processing */
  CONV_FROM_UTF8_FUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 144,

  /* if the connection proceeds too quickly then need to slow it down */
  /* limit-rate: maximum number of bytes per second to send or receive */
  MAX_SEND_SPEED_LARGE = CURLOPTTYPE_OFF_T + 145,
  MAX_RECV_SPEED_LARGE = CURLOPTTYPE_OFF_T + 146,

  /* Pointer to command string to send if USER/PASS fails. */
  FTP_ALTERNATIVE_TO_USER = CURLOPTTYPE_OBJECTPOINT + 147,

  /* callback function for setting socket options */
  SOCKOPTFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 148,
  SOCKOPTDATA = CURLOPTTYPE_OBJECTPOINT + 149,

  /* set to 0 to disable session ID re-use for this transfer, default is
     enabled (== 1) */
  SSL_SESSIONID_CACHE = CURLOPTTYPE_LONG + 150,

  /* allowed SSH authentication methods */
  SSH_AUTH_TYPES = CURLOPTTYPE_LONG + 151,

  /* Used by scp/sftp to do public/private key authentication */
  SSH_PUBLIC_KEYFILE = CURLOPTTYPE_OBJECTPOINT + 152,
  SSH_PRIVATE_KEYFILE = CURLOPTTYPE_OBJECTPOINT + 153,

  /* Send CCC (Clear Command Channel) after authentication */
  FTP_SSL_CCC = CURLOPTTYPE_LONG + 154,

  /* Same as TIMEOUT and CONNECTTIMEOUT, but with ms resolution */
  TIMEOUT_MS = CURLOPTTYPE_LONG + 155,
  CONNECTTIMEOUT_MS = CURLOPTTYPE_LONG + 156,

  /* set to zero to disable the libcurl's decoding and thus pass the raw body
     data to the application even when it is encoded/compressed */
  HTTP_TRANSFER_DECODING = CURLOPTTYPE_LONG + 157,
  HTTP_CONTENT_DECODING = CURLOPTTYPE_LONG + 158,

  /* Permission used when creating new files and directories on the remote
     server for protocols that support it, SFTP/SCP/FILE */
  NEW_FILE_PERMS = CURLOPTTYPE_LONG + 159,
  NEW_DIRECTORY_PERMS = CURLOPTTYPE_LONG + 160,

  /* Set the behaviour of POST when redirecting. Values must be set to one
     of CURL_REDIR* defines below. This used to be called POST301 */
  POSTREDIR = CURLOPTTYPE_LONG + 161,

  /* used by scp/sftp to verify the host's public key */
  SSH_HOST_PUBLIC_KEY_MD5 = CURLOPTTYPE_OBJECTPOINT + 162,

  /* Callback function for opening socket (instead of socket(2)). Optionally,
     callback is able change the address or refuse to connect returning
     CURL_SOCKET_BAD.  The callback should have type
     curl_opensocket_callback */
  OPENSOCKETFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 163,
  OPENSOCKETDATA = CURLOPTTYPE_OBJECTPOINT + 164,

  /* POST volatile input fields. */
  COPYPOSTFIELDS = CURLOPTTYPE_OBJECTPOINT + 165,

  /* set transfer mode (,type=<a|i>) when doing FTP via an HTTP proxy */
  PROXY_TRANSFER_MODE = CURLOPTTYPE_LONG + 166,

  /* Callback function for seeking in the input stream */
  SEEKFUNCTION = CURLOPTTYPE_FUNCTIONPOINT + 167,
  SEEKDATA = CURLOPTTYPE_OBJECTPOINT + 168,

  /* CRL file */
  CRLFILE = CURLOPTTYPE_OBJECTPOINT + 169,

  /* Issuer certificate */
  ISSUERCERT = CURLOPTTYPE_OBJECTPOINT + 170,

  /* (IPv6) Address scope */
  ADDRESS_SCOPE = CURLOPTTYPE_LONG + 171,

  /* Collect certificate chain info and allow it to get retrievable with
     CURLINFO_CERTINFO after the transfer is complete. (Unfortunately) only
     working with OpenSSL-powered builds. */
  CERTINFO = CURLOPTTYPE_LONG + 172,

  /* "name" and "pwd" to use when fetching. */
  USERNAME = CURLOPTTYPE_OBJECTPOINT + 173,
  PASSWORD = CURLOPTTYPE_OBJECTPOINT + 174,

    /* "name" and "pwd" to use with Proxy when fetching. */
  PROXYUSERNAME = CURLOPTTYPE_OBJECTPOINT + 175,
  PROXYPASSWORD = CURLOPTTYPE_OBJECTPOINT + 176,

  /* Comma separated list of hostnames defining no-proxy zones. These should
     match both hostnames directly, and hostnames within a domain. For
     example, local.com will match local.com and www.local.com, but NOT
     notlocal.com or www.notlocal.com. For compatibility with other
     implementations of this, .local.com will be considered to be the same as
     local.com. A single * is the only valid wildcard, and effectively
     disables the use of proxy. */
  NOPROXY = CURLOPTTYPE_OBJECTPOINT + 177,

  /* block size for TFTP transfers */
  TFTP_BLKSIZE = CURLOPTTYPE_LONG + 178,

  /* Socks Service */
  SOCKS5_GSSAPI_SERVICE = CURLOPTTYPE_LONG + 179,

  /* Socks Service */
  SOCKS5_GSSAPI_NEC = CURLOPTTYPE_LONG + 180,

  /* set the bitmask for the protocols that are allowed to be used for the
     transfer, which thus helps the app which takes URLs from users or other
     external inputs and want to restrict what protocol(s) to deal
     with. Defaults to CURLPROTO_ALL. */
  PROTOCOLS = CURLOPTTYPE_LONG + 181,

  /* set the bitmask for the protocols that libcurl is allowed to follow to,
     as a subset of the PROTOCOLS ones. That means the protocol needs
     to be set in both bitmasks to be allowed to get redirected to. Defaults
     to all protocols except FILE and SCP. */
  REDIR_PROTOCOLS = CURLOPTTYPE_LONG + 182,

  LASTENTRY /* the last unused */
    };

extern (C) {
  extern CURL* curl_easy_init();
  //extern CURLcode curl_easy_setopt(CURL* curl, CURLoption option, ...);
  extern CURLcode curl_easy_setopt(CURL* curl, CURLoption option,
				   ...);
  extern CURLcode curl_easy_perform(CURL* curl);
  extern void curl_easy_cleanup(CURL* curl);
  //CURL_EXTERN CURLcode curl_easy_getinfo(CURL *curl, CURLINFO info, ...);
}  

CURLcode setopt(CURL* curl, CURLoption option, string value) {
  return curl_easy_setopt(curl, option, toStringz(value));
}
CURLcode setopt(CURL* curl, CURLoption option, long value) {
  return curl_easy_setopt(curl, option, value);
}

CURLcode setopt(CURL* curl, CURLoption option, void* value) {
  return curl_easy_setopt(curl, option, value);
}

void setfunc(CURL* curl, CURLoption option, void* value) {
  curl_easy_setopt(curl, option, value);
}

extern (C) size_t wfunc (const char* str, size_t c, size_t l, FILE* ptr) {
  writefln("[[[%s]]]", str[0..c*l]);
  return c*l;
}






class Curl {
  
  CURL* handle;

  this() {
    handle = curl_easy_init();
    CURL* curl = curl_easy_init();
    set(CURLoption.FILE, cast(void*) this);
    set(CURLoption.WRITEHEADER, cast(void*) this);
    set(CURLoption.WRITEFUNCTION, cast(void*) &Curl.writeCallback);
    set(CURLoption.HEADERFUNCTION, cast(void*) &Curl.headerCallback);
  }

  this(string url) {
    this();
    set(CURLoption.URL, url);
  }

  ~this() {
    curl_easy_cleanup(this.handle);
  }

  void _check(CURLcode code) {
    if (code != CURLcode.CURLE_OK) {
      throw new Exception(to!string(code));
    }
  }

  void set(CURLoption option, string value) {
    _check(curl_easy_setopt(this.handle, option, toStringz(value)));
  }

  void set(CURLoption option, long value) {
    _check(curl_easy_setopt(this.handle, option, value));
  }

  void set(CURLoption option, void* value) {
    _check(curl_easy_setopt(this.handle, option, value));
  }


  void perform() {
    _check(curl_easy_perform(this.handle));
  }

  void dataReceived(const char[] s) {
    write(s);
  }

  char[] firstLine = null;
  string[string] headers;

  void headerReceived(const char[] s) {
    if (firstLine == null) {
      firstLine = cast(char[]) s;
    } else {
      auto m = match(cast(char[]) s, regex("(.*?): (.*)$"));
      if (!m.empty) {
	headers[to!string(m.captures[1])] = to!string(m.captures[2]);
      }

    }
  }

  extern (C) static size_t writeCallback(const char* str, size_t c, size_t l, void* ptr) {
    Curl b = cast(Curl) ptr;
    b.dataReceived(str[0..c*l]);
    return c*l;
  }

  extern (C) static size_t headerCallback(const char* str, size_t c, size_t l, void* ptr) {
    Curl b = cast(Curl) ptr;
    auto s = str[0..c*l].chomp;
    b.headerReceived(s);
    return c*l;
  }
}







/*
void _main(string[] args) {
  string url = args.length > 1 ? args[1] : "http://localhost/";
  class DgCurl : Curl {
    void delegate(const char[]) receiver;
    this(string s, void delegate(const char[]) dg) { 
      super(s); 
      receiver = dg;
    }
    void dataReceived(const char[] s) {
      receiver(s);
    }
  }
  auto c = new DgCurl (url, delegate void(const char[] s) { 
      writeln(s.toupper()); 
    });
  c.perform;
  writefln("\nheaders: %s", c.headers);
}
*/