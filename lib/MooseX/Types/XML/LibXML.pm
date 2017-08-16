package MooseX::Types::XML::LibXML;

# ABSTRACT: Type constraints for LibXML classes

=head1 DESCRIPTION

This is a L<Moose|Moose> type library for some common types used with and by
L<XML::LibXML|XML::LibXML>.

=head1 SEE ALSO

=over

=item L<XML::LibXML|XML::LibXML>

=item L<Moose::Manual::Types|Moose::Manual::Types>

=back

=cut

use utf8;
use Modern::Perl;

# VERSION
use English '-no_match_vars';
use MooseX::Types -declare => [qw(Document XMLNamespaceMap XPathExpression)];
use MooseX::Types::Moose qw(HashRef Str);
use MooseX::Types::Path::Class 'File';
use MooseX::Types::URI 'Uri';
use URI;
use XML::LibXML;
use namespace::autoclean;

## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)

=type Document

L<XML::LibXML::Document|XML::LibXML::Document> that coerces strings,
L<Path::Class::File|Path::Class::File>s and L<URI|URI>s.

=cut

class_type Document, { class => 'XML::LibXML::Document' };
coerce Document, from Str, via { XML::LibXML->load_xml( string => $_ ) };
coerce Document, from File | Uri,    ## no critic (ProhibitBitwiseOperators)
    via { XML::LibXML->load_xml( location => $_ ) };

=type XMLNamespaceMap

Reference to a hash of L<URI|URI>s where the keys are XML namespace prefixes.
Coerces from a reference to a hash of strings.

=cut

subtype XMLNamespaceMap, as HashRef [Uri];
coerce XMLNamespaceMap, from HashRef [Str], via {
    ## no critic (ProhibitAccessOfPrivateData)
    my $hashref = $_;
    return { map { $_ => URI->new( $hashref->{$_} ) } keys %{$hashref} };
};

=type XPathExpression

L<XML::LibXML::XPathExpression|XML::LibXML::XPathExpression> that coerces
strings.

=cut

class_type XPathExpression, { class => 'XML::LibXML::XPathExpression' };
coerce XPathExpression, from Str,
    via { XML::LibXML::XPathExpression->new($_) };

1;
__END__

=head1 SYNOPSIS

    package MyParser;
    use Moose;
    use MooseX::Types::XML::LibXML ':all';
    use XML::LibXML::XPathContext;

    has xml_doc    => ( isa => Document, coerce => 1 );
    has namespaces => ( isa => XMLNamespaceMap, coerce => 1 );
    has xpath      => ( isa => XPathExpression, coerce => 1 );

    sub findnodes {
        my $self = shift;
        my $xpc  = XML::LibXML::XPathContext->new($self->xml_doc);
        while ( my ($prefix, $uri) = each %{$self->namespaces} ) {
            $xpc->registerNs($prefix, "$uri");
        }
        return $xpc->findnodes($self->xpath);
    }

    package main;
    use Path::Class;

    my $para_parser = MyParser->new(
        xml_doc    => file('foo.xhtml'),
        namespaces => { xhtml => 'http://www.w3.org/1999/xhtml' },
        xpath      => '//xhtml:p',
    );

    print $para_parser->findnodes->to_literal, "\n";
