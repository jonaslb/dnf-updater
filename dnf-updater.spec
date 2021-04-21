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
Source10: LICENSE
BuildRequires: desktop-file-utils systemd-rpm-macros
Requires: systemd libnotify bash

%description
Dnf-updater is an icon that you can click to basically call dnf update.
It also uses a systemd timer to send reminders in case there are updates available.

%global debug_package %{nil}

%prep
#%setup -q

%build

%install
install -Dm 0755 %{SOURCE0} -t %{buildroot}%{_bindir}
install -Dm 0755 %{SOURCE1} -t %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_userunitdir}
install -m 0644 %{SOURCE2} %{SOURCE3} %{buildroot}%{_userunitdir}
desktop-file-install --dir=%{buildroot}%{_datadir}/applications %{SOURCE4}

%post
#%systemd_user_post dnf-nag.timer
# Override Fedora and enable the timer by default.
# Unfortunately can't be started immediately, users must relog.
systemctl --global enable dnf-nag.timer

%preun
%systemd_user_preun dnf-nag.timer

%postun
%systemd_user_postun_with_restart dnf-nag.timer

%files
%license LICENSE
%{_bindir}/dnf-nag.sh
%{_bindir}/dnf-updater.sh
%{_userunitdir}/dnf-nag.service
%{_userunitdir}/dnf-nag.timer
%{_datadir}/applications/dnf-updater.desktop
