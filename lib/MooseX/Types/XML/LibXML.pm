package MooseX::Types::XML::LibXML;

# ABSTRACT: Type constraints for LibXML classes

use strict;
use English '-no_match_vars';
use MooseX::Types -declare => [qw(XMLNamespaceMap XPathExpression)];
use MooseX::Types::Moose qw(HashRef Str);
use MooseX::Types::URI 'Uri';
use URI;
use XML::LibXML;
use namespace::autoclean;

subtype XMLNamespaceMap,    ## no critic (ProhibitCallsToUndeclaredSubs)
    as HashRef [Uri];

coerce XMLNamespaceMap,     ## no critic (ProhibitCallsToUndeclaredSubs)
    from HashRef [Str], via {
    ## no critic (ProhibitAccessOfPrivateData)
    my $hashref = $ARG;
    return { map { $ARG => URI->new( $hashref->{$ARG} ) } keys %{$hashref} };
    };

class_type XPathExpression,    ## no critic (ProhibitCallsToUndeclaredSubs)
    { class => 'XML::LibXML::XPathExpression' };

coerce XPathExpression,        ## no critic (ProhibitCallsToUndeclaredSubs)
    from Str, via { XML::LibXML::XPathExpression->new($ARG) };

1;
