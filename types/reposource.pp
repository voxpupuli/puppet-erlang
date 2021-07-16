# Options for what Erlang package repository to be configured on the system.
# This type defines the union of all possible options for both Apt and Yum repos.
# However, each OS family has a different subset of requirements:
# For Debian/Ubuntu the choices for `repo_source` are:
#  - `'erlang_solutions'` (default)
#  - `'cloudsmith'`
#
# For CentOS/RHEL the choices for `repo_source` are:
#  - `'epel'`
#  - `'erlang_solutions'`
#  - `'packagecloud'` (default)
type Erlang::RepoSource = Enum['cloudsmith', 'epel', 'erlang_solutions', 'packagecloud']
