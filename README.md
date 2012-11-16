Hiera-puppet is in end-of-life
=====

As of the release of Puppet 3.0.0, hiera-puppet has been incorporated into the
puppet codebase. The standalone hiera-puppet is only needed for releases of
Puppet prior to 3.0.0, which are all in bug-fix only mode. The 1.x branch is
for those older versions of puppet and is only open for urgent bug-fixes.
However, do not submit fixes against this repository.

What do I do with bugs?
=====

File bugs for hiera-puppet against puppet itself and submit patches as pull
requests against puppet as well. If it is an urgent bug that is in hiera-puppet
1, then let us know and we will port the change over.

Links
====

* [The puppet codebase](https://github.com/puppetlabs/puppet)
* [Contributing to puppet](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md)
* [The puppet bug tracker](https://projects.puppetlabs.com/projects/puppet)
