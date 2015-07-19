# Change Log

## [v1.3.0](https://github.com/pearkes/tugboat/tree/v1.3.0) (2015-07-19)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v1.2.0...v1.3.0)

**Merged pull requests:**

- Implement single attribute fetcher and porcelain mode for droplet info command [\#170](https://github.com/pearkes/tugboat/pull/170) ([ethanal](https://github.com/ethanal))

## [v1.2.0](https://github.com/pearkes/tugboat/tree/v1.2.0) (2015-07-18)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v1.1.0...v1.2.0)

**Fixed bugs:**

- SSH to Private IP [\#169](https://github.com/pearkes/tugboat/issues/169)

**Closed issues:**

- Image list and authorize [\#163](https://github.com/pearkes/tugboat/issues/163)

**Merged pull requests:**

- Adds flavour text for listing global images [\#167](https://github.com/pearkes/tugboat/pull/167) ([petems](https://github.com/petems))

## [v1.1.0](https://github.com/pearkes/tugboat/tree/v1.1.0) (2015-07-18)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v2.0.0.ALPHA...v1.1.0)

**Closed issues:**

- Unable to bundle to run tugboat from git repo version for testing  [\#171](https://github.com/pearkes/tugboat/issues/171)

**Merged pull requests:**

- Update ssh to private ip [\#172](https://github.com/pearkes/tugboat/pull/172) ([petems](https://github.com/petems))

## [v2.0.0.ALPHA](https://github.com/pearkes/tugboat/tree/v2.0.0.ALPHA) (2015-07-18)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v1.0.0...v2.0.0.ALPHA)

**Closed issues:**

- 1.0.0 Release [\#125](https://github.com/pearkes/tugboat/issues/125)

## [v1.0.0](https://github.com/pearkes/tugboat/tree/v1.0.0) (2015-05-26)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.2.0...v1.0.0)

**Implemented enhancements:**

- regions sorting [\#164](https://github.com/pearkes/tugboat/issues/164)

- Add support to Destroy Image [\#72](https://github.com/pearkes/tugboat/issues/72)

**Closed issues:**

- Add Documentation for \#106 [\#153](https://github.com/pearkes/tugboat/issues/153)

- Not creating droplet with default ssh key [\#149](https://github.com/pearkes/tugboat/issues/149)

- Default image change \(and region load\) [\#148](https://github.com/pearkes/tugboat/issues/148)

- Error handling for API error. [\#138](https://github.com/pearkes/tugboat/issues/138)

- clarification about add-key [\#136](https://github.com/pearkes/tugboat/issues/136)

- --default option for add-key [\#135](https://github.com/pearkes/tugboat/issues/135)

- add-key ignores default set in ~/.tugboat [\#134](https://github.com/pearkes/tugboat/issues/134)

- root would be a better default username [\#131](https://github.com/pearkes/tugboat/issues/131)

- ~ and $HOME fail for key path [\#130](https://github.com/pearkes/tugboat/issues/130)

- tugboat images \[OPTIONS\] [\#127](https://github.com/pearkes/tugboat/issues/127)

- tugboat create --help actually creates "--help" droplet [\#126](https://github.com/pearkes/tugboat/issues/126)

- Action to list all images [\#117](https://github.com/pearkes/tugboat/issues/117)

- New API endpoint tests failing on Travis, work fine locally [\#109](https://github.com/pearkes/tugboat/issues/109)

- Multiple DO accounts [\#106](https://github.com/pearkes/tugboat/issues/106)

- Tilde is not interpreted as the home directory [\#105](https://github.com/pearkes/tugboat/issues/105)

- Tugboat Info Should Show Private IP If Exists [\#104](https://github.com/pearkes/tugboat/issues/104)

- Default image Id no longer exists [\#98](https://github.com/pearkes/tugboat/issues/98)

- list available images [\#97](https://github.com/pearkes/tugboat/issues/97)

- waiting for a state is inefficient [\#96](https://github.com/pearkes/tugboat/issues/96)

- Unable to run tugboat after installing [\#92](https://github.com/pearkes/tugboat/issues/92)

- Rebuild a droplet  with a new image [\#66](https://github.com/pearkes/tugboat/issues/66)

**Merged pull requests:**

- PR \#165 with tests [\#166](https://github.com/pearkes/tugboat/pull/166) ([petems](https://github.com/petems))

- Add docs for \#153 [\#159](https://github.com/pearkes/tugboat/pull/159) ([petems](https://github.com/petems))

- Update prompt text [\#158](https://github.com/pearkes/tugboat/pull/158) ([petems](https://github.com/petems))

- Update docs to clarify add-key command [\#157](https://github.com/pearkes/tugboat/pull/157) ([petems](https://github.com/petems))

- Run cucumber as part of the rake default task [\#156](https://github.com/pearkes/tugboat/pull/156) ([petems](https://github.com/petems))

- Change to expand path from ssh\_key\_path [\#155](https://github.com/pearkes/tugboat/pull/155) ([petems](https://github.com/petems))

- Change default user to 'root' [\#154](https://github.com/pearkes/tugboat/pull/154) ([petems](https://github.com/petems))

- Fixes incorrect link [\#152](https://github.com/pearkes/tugboat/pull/152) ([petems](https://github.com/petems))

- Add config cli method [\#151](https://github.com/pearkes/tugboat/pull/151) ([petems](https://github.com/petems))

- Change to Docker Travis [\#150](https://github.com/pearkes/tugboat/pull/150) ([petems](https://github.com/petems))

- Change the default image and region [\#147](https://github.com/pearkes/tugboat/pull/147) ([JamshedVesuna](https://github.com/JamshedVesuna))

- Resolve the SSH key path later. [\#146](https://github.com/pearkes/tugboat/pull/146) ([Ferada](https://github.com/Ferada))

- Add configuration option for using the public IP. [\#145](https://github.com/pearkes/tugboat/pull/145) ([Ferada](https://github.com/Ferada))

- Create help [\#143](https://github.com/pearkes/tugboat/pull/143) ([wadtech](https://github.com/wadtech))

- Fix typo [\#141](https://github.com/pearkes/tugboat/pull/141) ([seanhussey](https://github.com/seanhussey))

- Fix API key redacting for DEBUG=2 [\#140](https://github.com/pearkes/tugboat/pull/140) ([petems](https://github.com/petems))

- Handle HTML Error responses [\#139](https://github.com/pearkes/tugboat/pull/139) ([petems](https://github.com/petems))

- Changes to URL [\#137](https://github.com/pearkes/tugboat/pull/137) ([petems](https://github.com/petems))

- fix API URL in cli.rb [\#129](https://github.com/pearkes/tugboat/pull/129) ([brandondrew](https://github.com/brandondrew))

- Adds slugs to regions list. [\#121](https://github.com/pearkes/tugboat/pull/121) ([blakelapierre](https://github.com/blakelapierre))

- Add spec around confirming action with user [\#116](https://github.com/pearkes/tugboat/pull/116) ([petems](https://github.com/petems))

- Transpec fixes [\#114](https://github.com/pearkes/tugboat/pull/114) ([petems](https://github.com/petems))

- Trying to get that Coveralls % higher... [\#113](https://github.com/pearkes/tugboat/pull/113) ([petems](https://github.com/petems))

- Specs for fuzzy matching of images [\#112](https://github.com/pearkes/tugboat/pull/112) ([petems](https://github.com/petems))

- Fix error in 'authorize\_cli\_spec' [\#111](https://github.com/pearkes/tugboat/pull/111) ([petems](https://github.com/petems))

- Enable simplecov HTML formatter and Coveralls [\#110](https://github.com/pearkes/tugboat/pull/110) ([petems](https://github.com/petems))

- Change link for api [\#108](https://github.com/pearkes/tugboat/pull/108) ([petems](https://github.com/petems))

- Display + SSH to private IP [\#107](https://github.com/pearkes/tugboat/pull/107) ([WietseWind](https://github.com/WietseWind))

- Update the link to get v1 API keys in the README. [\#103](https://github.com/pearkes/tugboat/pull/103) ([wearhere](https://github.com/wearhere))

- Change the default image [\#100](https://github.com/pearkes/tugboat/pull/100) ([blom](https://github.com/blom))

- Add `\[OPTIONS\]` to images description [\#99](https://github.com/pearkes/tugboat/pull/99) ([blom](https://github.com/blom))

- Add MRI 1.9.2 and 2.1.0 to .travis.yml [\#94](https://github.com/pearkes/tugboat/pull/94) ([blom](https://github.com/blom))

- No more 1.8.7 [\#93](https://github.com/pearkes/tugboat/pull/93) ([blom](https://github.com/blom))

- added sort\_by when listing regions [\#165](https://github.com/pearkes/tugboat/pull/165) ([elliotthilaire](https://github.com/elliotthilaire))

- region one unavailable on some clients, use NYC 2 [\#144](https://github.com/pearkes/tugboat/pull/144) ([Thetoxicarcade](https://github.com/Thetoxicarcade))

- Load config file from current directory, if not exit load from defaults [\#123](https://github.com/pearkes/tugboat/pull/123) ([tg0](https://github.com/tg0))

- improves droplets list/info prints [\#115](https://github.com/pearkes/tugboat/pull/115) ([petems](https://github.com/petems))

- Improves droplets list/info prints [\#77](https://github.com/pearkes/tugboat/pull/77) ([nofxx](https://github.com/nofxx))

## [v0.2.0](https://github.com/pearkes/tugboat/tree/v0.2.0) (2014-02-15)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.9...v0.2.0)

**Implemented enhancements:**

- Add a --quiet option [\#86](https://github.com/pearkes/tugboat/issues/86)

- Add to homebrew? [\#83](https://github.com/pearkes/tugboat/issues/83)

**Closed issues:**

- Droplet create with backups enabled. [\#89](https://github.com/pearkes/tugboat/issues/89)

- certificate verify failed [\#84](https://github.com/pearkes/tugboat/issues/84)

- Destroy data by default... [\#81](https://github.com/pearkes/tugboat/issues/81)

**Merged pull requests:**

- destroy and info command [\#91](https://github.com/pearkes/tugboat/pull/91) ([PierreFrisch](https://github.com/PierreFrisch))

- Add rebuild command [\#90](https://github.com/pearkes/tugboat/pull/90) ([PierreFrisch](https://github.com/PierreFrisch))

- Fuzzy name searching is now case insensitive [\#88](https://github.com/pearkes/tugboat/pull/88) ([Vel0x](https://github.com/Vel0x))

- global: add a -q/--quiet flag [\#87](https://github.com/pearkes/tugboat/pull/87) ([pearkes](https://github.com/pearkes))

- Add backups\_enabled option on droplet creation \(-b true\) [\#82](https://github.com/pearkes/tugboat/pull/82) ([4n3w](https://github.com/4n3w))

## [v0.0.9](https://github.com/pearkes/tugboat/tree/v0.0.9) (2013-12-24)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.8...v0.0.9)

**Fixed bugs:**

- Cannot destroy droplet [\#67](https://github.com/pearkes/tugboat/issues/67)

**Closed issues:**

- Unable to authorize tugboat [\#79](https://github.com/pearkes/tugboat/issues/79)

- Problem with SSL certificate [\#70](https://github.com/pearkes/tugboat/issues/70)

- Option to manage SSH keys [\#69](https://github.com/pearkes/tugboat/issues/69)

- Enable Private Networking  [\#68](https://github.com/pearkes/tugboat/issues/68)

- Release 0.0.8 [\#65](https://github.com/pearkes/tugboat/issues/65)

- Add SSH key to account [\#60](https://github.com/pearkes/tugboat/issues/60)

**Merged pull requests:**

- require json at the top to avoid 2.0.0 issues [\#80](https://github.com/pearkes/tugboat/pull/80) ([pearkes](https://github.com/pearkes))

- updated default image from 12.04 x64 to 13.04 x64 [\#76](https://github.com/pearkes/tugboat/pull/76) ([obradovic](https://github.com/obradovic))

- Add private networking boolean option \(Ex. tugboat create -p true mydrop... [\#75](https://github.com/pearkes/tugboat/pull/75) ([4n3w](https://github.com/4n3w))

- Added ssh option for executing commands [\#73](https://github.com/pearkes/tugboat/pull/73) ([calebreach](https://github.com/calebreach))

- Upload SSH Key [\#64](https://github.com/pearkes/tugboat/pull/64) ([petems](https://github.com/petems))

- added optional private networking to create [\#74](https://github.com/pearkes/tugboat/pull/74) ([obradovic](https://github.com/obradovic))

## [v0.0.8](https://github.com/pearkes/tugboat/tree/v0.0.8) (2013-09-07)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.7...v0.0.8)

**Implemented enhancements:**

- Add ability to set default region [\#56](https://github.com/pearkes/tugboat/issues/56)

- Release 0.0.7 [\#54](https://github.com/pearkes/tugboat/issues/54)

- Handle 401s more gracefully... [\#53](https://github.com/pearkes/tugboat/issues/53)

- Scrub API Keys from Logs [\#42](https://github.com/pearkes/tugboat/issues/42)

**Fixed bugs:**

- Handle 401s more gracefully... [\#53](https://github.com/pearkes/tugboat/issues/53)

**Closed issues:**

- "undefined method `each' for nil:NilClass" in every endpoint [\#52](https://github.com/pearkes/tugboat/issues/52)

**Merged pull requests:**

- Faraday: Improve Error Messages [\#62](https://github.com/pearkes/tugboat/pull/62) ([pearkes](https://github.com/pearkes))

- Default droplet options [\#61](https://github.com/pearkes/tugboat/pull/61) ([petems](https://github.com/petems))

- Custom logging to filter logs [\#58](https://github.com/pearkes/tugboat/pull/58) ([petems](https://github.com/petems))

- Reset colors [\#57](https://github.com/pearkes/tugboat/pull/57) ([blom](https://github.com/blom))

- Custom faraday and verify method [\#55](https://github.com/pearkes/tugboat/pull/55) ([petems](https://github.com/petems))

## [v0.0.7](https://github.com/pearkes/tugboat/tree/v0.0.7) (2013-07-10)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.6...v0.0.7)

**Closed issues:**

- New release? [\#47](https://github.com/pearkes/tugboat/issues/47)

- tugboat authorize says I must run... authorize [\#41](https://github.com/pearkes/tugboat/issues/41)

**Merged pull requests:**

- Add response for no images found \(my-images filter\) [\#49](https://github.com/pearkes/tugboat/pull/49) ([petems](https://github.com/petems))

- Add response for no droplets found [\#48](https://github.com/pearkes/tugboat/pull/48) ([petems](https://github.com/petems))

## [v0.0.6](https://github.com/pearkes/tugboat/tree/v0.0.6) (2013-06-25)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.5...v0.0.6)

**Implemented enhancements:**

- "Wait" Tool [\#44](https://github.com/pearkes/tugboat/issues/44)

**Closed issues:**

- Error: Faraday::Error::ParsingError n-1.6.7/lib/json/common.rb:149:in `parse': 757 [\#37](https://github.com/pearkes/tugboat/issues/37)

- Release 0.0.5 [\#29](https://github.com/pearkes/tugboat/issues/29)

**Merged pull requests:**

- Wait [\#46](https://github.com/pearkes/tugboat/pull/46) ([pearkes](https://github.com/pearkes))

- Add a password reset command [\#45](https://github.com/pearkes/tugboat/pull/45) ([blom](https://github.com/blom))

- README: bring command documentation up to date [\#43](https://github.com/pearkes/tugboat/pull/43) ([pearkes](https://github.com/pearkes))

- Add a resize command [\#40](https://github.com/pearkes/tugboat/pull/40) ([blom](https://github.com/blom))

- Update the defaults for droplet creation [\#39](https://github.com/pearkes/tugboat/pull/39) ([pearkes](https://github.com/pearkes))

- Add a --ssh-opts option to the ssh command [\#38](https://github.com/pearkes/tugboat/pull/38) ([blom](https://github.com/blom))

- Add some tests for the help command [\#36](https://github.com/pearkes/tugboat/pull/36) ([blom](https://github.com/blom))

- Dry up the specs a bit [\#35](https://github.com/pearkes/tugboat/pull/35) ([blom](https://github.com/blom))

- Adjust the Coveralls configuration [\#34](https://github.com/pearkes/tugboat/pull/34) ([blom](https://github.com/blom))

- Run specs in a random order [\#33](https://github.com/pearkes/tugboat/pull/33) ([blom](https://github.com/blom))

- Add coveralls.io support [\#32](https://github.com/pearkes/tugboat/pull/32) ([pearkes](https://github.com/pearkes))

- Droplet State Checks [\#31](https://github.com/pearkes/tugboat/pull/31) ([pearkes](https://github.com/pearkes))

- Add a start command [\#30](https://github.com/pearkes/tugboat/pull/30) ([blom](https://github.com/blom))

## [v0.0.5](https://github.com/pearkes/tugboat/tree/v0.0.5) (2013-05-04)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.4...v0.0.5)

**Fixed bugs:**

- Return Proper Exit Codes [\#3](https://github.com/pearkes/tugboat/issues/3)

**Closed issues:**

- pass through ssh commands [\#26](https://github.com/pearkes/tugboat/issues/26)

- Supporting MRI 1.8.7 [\#20](https://github.com/pearkes/tugboat/issues/20)

- Add a command to list regions [\#17](https://github.com/pearkes/tugboat/issues/17)

**Merged pull requests:**

- Stub out Kernel.exec for testing the options sent to SSH. [\#28](https://github.com/pearkes/tugboat/pull/28) ([pearkes](https://github.com/pearkes))

- Add a power option to halt and restart [\#27](https://github.com/pearkes/tugboat/pull/27) ([blom](https://github.com/blom))

- Add an initial spec for the ssh command [\#24](https://github.com/pearkes/tugboat/pull/24) ([blom](https://github.com/blom))

- Add an ssh\_user option to the ssh command [\#23](https://github.com/pearkes/tugboat/pull/23) ([blom](https://github.com/blom))

- Support MRI 1.8.7 [\#22](https://github.com/pearkes/tugboat/pull/22) ([blom](https://github.com/blom))

- Status Codes [\#21](https://github.com/pearkes/tugboat/pull/21) ([pearkes](https://github.com/pearkes))

- Add a sizes command [\#19](https://github.com/pearkes/tugboat/pull/19) ([blom](https://github.com/blom))

- Add a regions command [\#18](https://github.com/pearkes/tugboat/pull/18) ([blom](https://github.com/blom))

- Add .travis.yml [\#16](https://github.com/pearkes/tugboat/pull/16) ([blom](https://github.com/blom))

- Add a power cycle command [\#25](https://github.com/pearkes/tugboat/pull/25) ([blom](https://github.com/blom))

## [v0.0.4](https://github.com/pearkes/tugboat/tree/v0.0.4) (2013-04-23)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.3...v0.0.4)

**Implemented enhancements:**

- Disable Confirmations Flag [\#7](https://github.com/pearkes/tugboat/issues/7)

- Add command to check for version [\#2](https://github.com/pearkes/tugboat/issues/2)

**Closed issues:**

- Allow configurable SSH port [\#12](https://github.com/pearkes/tugboat/issues/12)

- cli.rb:175: syntax error, unexpected '\)', expecting '=' \(SyntaxError\) [\#10](https://github.com/pearkes/tugboat/issues/10)

- Destroy droplet without confirmation [\#9](https://github.com/pearkes/tugboat/issues/9)

- Unable to authorise [\#8](https://github.com/pearkes/tugboat/issues/8)

**Merged pull requests:**

- All of the specs [\#15](https://github.com/pearkes/tugboat/pull/15) ([pearkes](https://github.com/pearkes))

- Add a version command [\#14](https://github.com/pearkes/tugboat/pull/14) ([blom](https://github.com/blom))

- Allow options for custom ssh port [\#13](https://github.com/pearkes/tugboat/pull/13) ([PhilETaylor](https://github.com/PhilETaylor))

- fix for SyntaxError [\#11](https://github.com/pearkes/tugboat/pull/11) ([PhilETaylor](https://github.com/PhilETaylor))

## [v0.0.3](https://github.com/pearkes/tugboat/tree/v0.0.3) (2013-04-15)

[Full Changelog](https://github.com/pearkes/tugboat/compare/v0.0.2...v0.0.3)

**Fixed bugs:**

- Specifying ID on FindDroplet Breaks [\#1](https://github.com/pearkes/tugboat/issues/1)

## [v0.0.2](https://github.com/pearkes/tugboat/tree/v0.0.2) (2013-04-14)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*