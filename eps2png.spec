# -*- rpm-spec -*-

Name: eps2png
Version: 2.6
Release: 1
Source: %{name}-%{version}.tar.gz
BuildArch: noarch
URL: http://johan.vromans.org/software/sw_eps2png.html
BuildRoot: %{_tmppath}/rpm-buildroot-%{name}-%{version}-%{release}
Vendor: Squirrel Consultancy
Packager: Johan Vromans <jvromans@squirrel.nl>

Summary: eps2png converts EPS to PNG, JPG and GIF.
License: Perl
Group: Applications/Graphics

%description
Converts files from EPS format (Encapsulated PostScript) to some
popular image formats.

%prep
%setup -q -n %{name}-%{version}

%build
%{__perl} Makefile.PL
make all
make test

%install
rm -rf $RPM_BUILD_ROOT
%{__mkdir} -p $RPM_BUILD_ROOT%{_bindir}
%{__install} -m 0775 script/%{name} $RPM_BUILD_ROOT%{_bindir}/%{name}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc CHANGES README
%{_bindir}/%{name}

%changelog
* Tue Mar 27 2008 Johan Vromans <jvromans@squirrel.nl>
- Initial version.
