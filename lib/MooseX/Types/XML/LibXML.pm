#
# This file is part of MooseX-Types-XML-LibXML
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

package MooseX::Types::XML::LibXML;

BEGIN {
    $MooseX::Types::XML::LibXML::VERSION = '0.001';
}

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

class_type Document,    ## no critic (ProhibitCallsToUndeclaredSubs)
    { class => 'XML::LibXML::Document' };

coerce Document,        ## no critic (ProhibitCallsToUndeclaredSubs)
    from Str, via { XML::LibXML->load_xml( string => $ARG ) };

coerce Document,        ## no critic (ProhibitCallsToUndeclaredSubs)
    from 'Path::Class::File | Uri',
    via { XML::LibXML->load_xml( location => $ARG ) };

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

__END__

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

MooseX::Types::XML::LibXML - Type constraints for LibXML classes

=head1 VERSION

version 0.001

=head1 TYPES

=head2 Document

L<XML::LibXML::Document> that coerces strings,
L<Path::Class::File|Path::Class::File>s and L<URI|URI>s.

=head2 XMLNamespaceMap

Reference to a hash of L<URI|URI>s where the keys are XML namespace prefixes.
Coerces from a reference to a hash of strings.

=head2 XPathExpression

L<XML::LibXML::XPathExpression> that coerces strings.

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc MooseX::Types::XML::LibXML

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/MooseX-Types-XML-LibXML>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Types-XML-LibXML>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annonations of Perl module documentation.

L<http://annocpan.org/dist/MooseX-Types-XML-LibXML>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/MooseX-Types-XML-LibXML>

=item *

CPAN Forum

The CPAN Forum is a web forum for discussing Perl modules.

L<http://cpanforum.com/dist/MooseX-Types-XML-LibXML>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.perl.org/dist/overview/MooseX-Types-XML-LibXML>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/M/MooseX-Types-XML-LibXML>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual way to determine what Perls/platforms PASSed for a distribution.

L<http://matrix.cpantesters.org/?dist=MooseX-Types-XML-LibXML>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=MooseX::Types::XML::LibXML>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at L<https://github.com/mjgardner/moosex-types-xml-libxml/issues>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/mjgardner/moosex-types-xml-libxml>

  git clone git://github.com/mjgardner/moosex-types-xml-libxml.git

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by GSI Commerce.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
