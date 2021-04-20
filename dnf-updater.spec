Name: dnf-updater
Version: 1.0
Release: 1%{?dist}
Summary: DNF Updater icon and nagging

License: GPLv3
URL: https://github.com/jonaslb/dnf-updater
Source0: dnf-nag.sh
Source1: dnf-updater.sh
Source2: dnf-nag.service
Source3: dnf-nag.timer
Source4: dnf-updater.desktop
BuildRequires: desktop-file-utils systemd-rpm-macros
Requires: systemd

%description
Dnf-updater is an icon that you can click to basically call dnf update.
It also uses a systemd timer to send reminders in case there are updates available.

%global debug_package %{nil}

%prep
#%setup -q

%build

%install
install -m 0755 %{SOURCE0} %{buildroot}%{_bindir}/dnf-nag.sh
install -m 0755 %{SOURCE1} %{buildroot}%{_bindir}/dnf-updater.sh
install -m 0644 %{SOURCE2} %{SOURCE3} %{buildroot}%{_userunitdir}
desktop-file-install --dir=%{buildroot}%{_datadir}/applications %{SOURCE4}

%post
%systemd_post soft-fn.service
systemctl --global enable dnf-updater.timer
systemctl start dnf-updater

%preun
%systemd_preun soft-fn.service

%postun
%systemd_postun_with_restart soft-fn.service

%files
%license LICENSE
%{_bindir}/dnf-nag.sh
%{_bindir}/dnf-updater.sh
%{_userunitdir}/dnf-nag.service
%{_userunitdir}/dnf-nag.timer
%{_datadir}/applications/dnf-updater.desktop
