# Plone expects Zope2 to load ``./etc/site.zcml`` from ``instancehome``.

{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "plone";
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    mkdir -p $out/etc
    cat > $out/etc/site.zcml << EOF
    <configure
        xmlns="http://namespaces.zope.org/zope"
        xmlns:meta="http://namespaces.zope.org/meta"
        xmlns:five="http://namespaces.zope.org/five">

      <include package="Products.Five" />
      <meta:redefinePermission from="zope2.Public" to="zope.Public" />

      <!-- Load the meta -->
      <include files="package-includes/*-meta.zcml" />
      <five:loadProducts file="meta.zcml"/>

      <!-- Load the configuration -->
      <include files="package-includes/*-configure.zcml" />
      <five:loadProducts />

      <!-- Load the configuration overrides-->
      <includeOverrides files="package-includes/*-overrides.zcml" />
      <five:loadProductsOverrides />

      <securityPolicy
          component="AccessControl.security.SecurityPolicy" />

    </configure>
    EOF
  '';
}
