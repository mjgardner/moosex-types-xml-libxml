package MooseX::Types::XML::LibXML;

# ABSTRACT: Type constraints for LibXML classes

use strict;
use English '-no_match_vars';
use MooseX::Types -declare => [qw(Document XMLNamespaceMap XPathExpression)];
use MooseX::Types::Moose qw(HashRef Str);
use MooseX::Types::Path::Class 'File';
use MooseX::Types::URI 'Uri';
use URI;
use XML::LibXML;
use namespace::autoclean;

=type Document

L<XML::LibXML::Document|XML::LibXML::Document> that coerces strings,
L<Path::Class::File|Path::Class::File>s and L<URI|URI>s.

=cut

class_type Document,    ## no critic (ProhibitCallsToUndeclaredSubs)
    { class => 'XML::LibXML::Document' };

coerce Document,        ## no critic (ProhibitCallsToUndeclaredSubs)
    from Str, via { XML::LibXML->load_xml( string => $ARG ) };

coerce Document,        ## no critic (ProhibitCallsToUndeclaredSubs)
    from File | Uri, via { XML::LibXML->load_xml( location => $ARG ) };

=type XMLNamespaceMap

Reference to a hash of L<URI|URI>s where the keys are XML namespace prefixes.
Coerces from a reference to a hash of strings.

=cut

subtype XMLNamespaceMap,    ## no critic (ProhibitCallsToUndeclaredSubs)
    as HashRef [Uri];

coerce XMLNamespaceMap,     ## no critic (ProhibitCallsToUndeclaredSubs)
    from HashRef [Str], via {
    ## no critic (ProhibitAccessOfPrivateData)
    my $hashref = $ARG;
    return { map { $ARG => URI->new( $hashref->{$ARG} ) } keys %{$hashref} };
    };

=type XPathExpression

L<XML::LibXML::XPathExpression|XML::LibXML::XPathExpression> that coerces
strings.

=cut

class_type XPathExpression,    ## no critic (ProhibitCallsToUndeclaredSubs)
    { class => 'XML::LibXML::XPathExpression' };

coerce XPathExpression,        ## no critic (ProhibitCallsToUndeclaredSubs)
    from Str, via { XML::LibXML::XPathExpression->new($ARG) };

1;
__END__

=head1 SYNOPSIS

    use Moose;
    use MooseX::Types::XML::LibXML ':all';

    has xml_doc    => ( isa => Document );
    has namespaces => ( isa => XMLNamespaceMap );
    has xpath      => ( isa => XPathExpression );

=head1 DESCRIPTION

This is a L<Moose|Moose> type library for some common types used with and by
L<XML::LibXML|XML::LibXML>.

=head1 SEE ALSO

=over

=item <XML::LibXML|XML::LibXML>

=item <Moose::Manual::Types|Moose::Manual::Types>

=back
