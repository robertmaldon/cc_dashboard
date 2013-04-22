# cc_dashboard - Aggregates the build status of projects from multiple CruiseControl servers on to a single "dashboard" web page

[http://github.com/robertmaldon/cc_dashboard](http://github.com/robertmaldon/cc_dashboard)

cc_dashboard will combine the build status of projects from multiple CruiseControl servers (actually, from any Continuous Integration server that exposes build status information using the "cctray xml format" - see below) on to a single "dashboard" web page.

cc_dashboard is a Rails 3.2 application. It has been tested against Ruby 1.9.3, but because it is very, very simple it should run under earlier versions of 1.9. (Rails 3.1 dropped support for Ruby 1.8.7.)

# Why cc_dashboard?

As the number of Rails projects I was using increased I was then forced to split them amongst multiple CruiseControl.rb servers to improve build times. However, I now had the problem of monitoring multiple CruiseControl.rb servers. So the answer was to aggregate all the build status using cc_dashboard!

Why did I write it in Rails? Because I was working with a large number of Rails projects at the time and had the Rails infrastructure in place to host cc_dashboard!

(Another approach to this problem could have been to use continuous integration servers that support master/multiple slaves configurations like Jenkins, but it wasn't an options at the time.)

# Installation

Assuming you have the base Rails gems installed (no database needed):

- Install ruby 1.9.2 or later and bundler
- Unpack the cc_dashboard zip/tar
- Create a **config/cc\_dashboard\_config.rb** file with a list of "cctray xml format" (see below) feed URLs. You can use **config/cc\_dashboard\_config.rb.example** as a template
- Install the dependent gems by doing a **bundle install**
- Start the cc_dashboard Rails server by running the **start.sh** script
- Point your web browser at the application root. e.g.

  [http://localhost:3332/](http://localhost:3332/)

To stop the cc_dashboard Rails server run the **stop.sh** script.

Note to Rails gurus: The start.sh and stop.sh scripts use Unicorn, but if you like you can use Webrick (e.g. "rails server -p 3332 -e production"), or Thin, or you can deploy behind Passenger, or use whatever server you like. You can also bind to whatever TCP port you like.

# Skins

cc_dashboard has support for changing the look, or "skin", of its dashboard page.

Available skins are:

* **doom** - yep, the original first-person shooter Doom
* **hudson** - some images borrowed from the [Hudson continuous integration server](https://hudson.dev.java.net/)
* **iskin** - all things Apple and the cult of Steve Jobs
* **kitten** - aaawww, how cute :)
* **nightmare** - primarily Nightmare on Elm Street, but throw in some other horror schlock from Jason vs Freddy, Chucky, etc
* **smiley**
* **spaceinvaders** - yep, the arcade classic
* **worldcup** - a.k.a. soccer

You choose the skin by setting the **DashboardConfig.skin** value in the **config/cc\_dashboard\_config.rb** configuration file. You can also choose the skin per-HTTP-request by adding a "?skin=SKIN" to the end of the URL (e.g. "?skin=hudson").

# Bling

To make the dahsboard a little less boring you can add some "bling". Built-in blings are:

* **cheezburger** - a random image from the [Cheezburger Network](http://cheezburger.com/)
* **chucknorris** - Chuck Norris is the ultimate programmer! 

You choose the bling by setting the **DashboardConfig.bling** value in the **config/cc\_dashboard\_config.rb** configuration file. You can also choose the bling per-HTTP-request by adding a "?bling=BLING" to the end of the URL (e.g. "?bling=cheezburger").

# (Sound) Tracks

cc_dashboard can play sounds to alert you when:

1. a build breaks
2. a build is still broken
3. a build was broken but is now fixed

Available tracks are:

* **aliens** - sound bites from the classic "Aliens" movie. Game over!
* **itrack** - some wisdom from Steve Jobs
* **nightmare** - sound bites from the schlock horror movies like Nightmare on Elm Street and Saw
* **simpsons** - sound bites from the animated "satirical parody of a middle class American lifestyle" sitcom. Doh!

You choose the track by setting the **DashboardConfig.track** value in the **config/cc\_dashboard\_config.rb** configuration file, or leave the configuration commented out to disable sounds. You can also choose the track per-HTTP-request by adding a "?track=TRACK" to the end of the URL (e.g. "?track=aliens").

NOTE: Tracks will only work on browsers that support the HTML5 audio and storage APIs. WAVs seem to be the most widely supported cross-browser audio format.

# Alarms

It can be helpful to get a reminder for upcoming important events of the day, such as the Daily Standup. cc_dashboard can be configured to display a clock and an audible alarm - either a text-to-speech mesage (see note on speak.js) or a ['24' digital clock 'plink' sound](http://www.urbandictionary.com/define.php?term=plink) - to help remind you of these events.

See the **DashboardConfig.alarm** section in the **config/cc\_dashboard\_config.rb** configuration file for examples. More than one alarm can be configured.

NOTE: Alarms will only work on browsers that support HTML 5 audio and @font-family.

# Widgets

You can display a number of widgets - which can show all sorts of useful information such as the weather forecast - at the bottom right of the dashboard.

Widgets include:

* weather_clock - Displays the current time and weather forecast. The browser's geo location is determined using the [Yahoo! PlaceFinder API](http://developer.yahoo.com/geo/placefinder/) and the forecast is fetched every hour from the [Yahoo! Weather RSS Feed](http://developer.yahoo.com/weather/).

See the **DashboardConfig.widgets** section in the **config/cc\_dashboard\_config.rb** configuration file for examples.

# "cctray xml format"

Originally developed for CruiseControl.NET, the "cctray xml format" is an RSS-like way of exposing the build status of projects. This format has caught on and is now supported by a number of continuous integration servers:

* [CruiseControl.rb](http://cruisecontrolrb.thoughtworks.com/) - http://cc.rb.servername:3333/XmlStatusReport.aspx
* [CruiseControl](http://cruisecontrol.sourceforge.net/) - http://cc.java.servername:8080/cctray.xml
* [CruiseControl.NET](http://ccnet.thoughtworks.com/) - http://cc.net.servername/XmlStatusReport.aspx
* [Jenkins](http://jenkins-ci.org/) - http://jenkins.servername:8080/cc.xml
* [Hudson](https://hudson.dev.java.net/) - http://hudson.servername:8080/cc.xml
* [Travis CI](http://travis-ci.org/) - http://travis-ci.org/ownername/repositoryname/cc.xml

See [Multiple Project Summary Reporting Standard](http://confluence.public.thoughtworks.org/display/CI/Multiple+Project+Summary+Reporting+Standard) for details of the cctray XML feed format (or see a copy of this doco in the next section below). This doco is mostly correct, the only difference i've seen "in the wild" are:

* An additional "Pending" activity
* An additional "Unknown" status. I've seen Unknown reported by CruiseControl.rb when project builds are serialized ("Configuration.serialize_builds = true" set in .cruise/site_config.rb) and one build is waiting for another build to finish. I've seen Unknown reported by Hudson when a project is disabled.

btw, [cctray](http://confluence.public.thoughtworks.org/display/CCNET/CCTray) is a .NET application that sits in your Windows system tray and can alert you via popups or sounds when a project build is successful or fails. It is available as part of a [CruiseControl.NET release](http://sourceforge.net/projects/ccnet/files/CruiseControl.NET%20Releases/).

[ccmenu](http://ccmenu.sourceforge.net/) is a cctray equivalent for the Mac.

# Multiple Project Summary Reporting Standard

NOTE: This is a copy of [Multiple Project Summary Reporting Standard](http://confluence.public.thoughtworks.org/display/CI/Multiple+Project+Summary+Reporting+Standard) which I include here because that wiki often seems to be down.

## Introduction

Various Continuous Integration monitoring / reporting tools exist. Examples are:

* [CruiseControl.NET's CCTray](http://confluence.public.thoughtworks.org/display/CCNET/CCTray)
* [CruiseControl Firefox Plugin](http://www.md.pp.ru/mozilla/cc/)
* [CCMenu for Mac](http://sourceforge.net/projects/ccmenu/)

These tools work by polling Continuous Integration servers for summary information and presenting it appropriately to users.

If a Continuous Integration server can offer a standard summary format, and a reporting tool can consume the same, then we get interoperability between reporting tools and CI Servers.

## Description

Summary information will be available as a plain XML string retrievable through an http GET request.

The format of the XML will be as follows:

### Summary

A single <Projects> node, the document root, which contains 0 or many <Project> node.

Each <Project> may have the following attributes:

<table>

	<tbody>

        <tr>

            <th> name </th>

            <th> description </th>

            <th> type </th>

            <th> required </th>

        </tr>

        <tr>

            <td> name </td>

            <td> The name of the project </td>

            <td> string </td>

            <td> yes </td>

        </tr>

        <tr>

            <td> activity </td>

            <td> The current state of the project </td>

            <td> string enum : Sleeping, Building, CheckingModifications <br clear="all" /> </td>

            <td> yes </td>
        </tr>

        <tr>

            <td> lastBuildStatus </td>

            <td> A brief description of the last build </td>

            <td> string enum : Success, Failure, Exception, Unknown </td>

            <td> yes </td>

        </tr>

        <tr>

            <td> lastBuildLabel </td>

            <td> A referential name for the last build </td>

            <td> string </td>

            <td> no </td>

        </tr>

        <tr>

            <td> lastBuildTime </td>

            <td> When the last build occurred </td>

            <td> DateTime </td>

            <td> yes </td>

        </tr>

        <tr>

            <td> nextBuildTime </td>

            <td> When the next build is scheduled to occur (or when the next check to see whether a build should be performed is scheduled to occur) </td>

            <td> DateTime </td>

            <td> no </td>

        </tr>

        <tr>

            <td> webUrl </td>

            <td> A URL for where more detail can be found about this project </td>

            <td> string (URL) </td>

            <td> yes </td>

        </tr>

    </tbody>

</table>

Clients that consume this XML should not rely on any optional attribute being present, and should degrade their functionality gracefully.

## Example

    <Projects>
        <Project
            name="SvnTest"
            activity="Sleeping"
            lastBuildStatus="Exception"
            lastBuildLabel="8"
            lastBuildTime="2005-09-28T10:30:34.6362160+01:00"
            nextBuildTime="2005-10-04T14:31:52.4509248+01:00"
            webUrl="http://mrtickle/ccnet/"/>

        <Project
            name="HelloWorld"
            activity="Sleeping"
            lastBuildStatus="Success"
            lastBuildLabel="13"
            lastBuildTime="2005-09-15T17:33:07.6447696+01:00"
            nextBuildTime="2005-10-04T14:31:51.7799600+01:00"
            webUrl="http://mrtickle/ccnet/"/>
    </Projects>

## Schema

    <?xml version="1.0" encoding="UTF-8" ?>
    <xs:schema elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="Projects">
    <xs:complexType>
    <xs:sequence>
    <xs:element name="Project" maxOccurs="unbounded">
    <xs:complexType>
    <xs:attribute name="name" type="xs:NMTOKEN" use="required" />
    <xs:attribute name="activity" use="required">
    <xs:simpleType>
    <xs:restriction base="xs:NMTOKEN">
    <xs:enumeration value="Sleeping" />
    <xs:enumeration value="Building" />
    <xs:enumeration value="CheckingModifications" />
    </xs:restriction>
    </xs:simpleType>
    </xs:attribute>
    <xs:attribute name="lastBuildStatus" use="required">
    <xs:simpleType>
    <xs:restriction base="xs:NMTOKEN">
    <xs:enumeration value="Exception" />
    <xs:enumeration value="Success" />
    <xs:enumeration value="Failure" />
    <xs:enumeration value="Unknown" />
    </xs:restriction>
    </xs:simpleType>
    </xs:attribute>
    <xs:attribute name="lastBuildLabel" type="xs:NMTOKEN" use="required" />
    <xs:attribute name="lastBuildTime" type="xs:dateTime" use="required" />
    <xs:attribute name="nextBuildTime" type="xs:dateTime" use="optional" />
    <xs:attribute name="webUrl" type="xs:string" use="required" />
    </xs:complexType>
    </xs:element>
    </xs:sequence>
    </xs:complexType>
    </xs:element>
    </xs:schema>

# CruiseControl.rb cctray times in the wrong timezone bug

CruiseControl.rb versions 1.4.0 and 1.3.0 (and probably earlier versions) incorrectly report local server time as UTC in the cctray feeds. To fix change the following method in lib/time_formatter.rb

    def round_trip_local(time)
      time.strftime('%Y-%m-%dT%H:%M:%S.0000000-00:00') # yyyy'-'MM'-'dd'T'HH':'mm':'ss.fffffffK)
    end

to

    def round_trip_local(time)
      time.xmlschema
    end

# Supported Browsers

cc_dashboard has been tested successfully against Chrome 17.0, Firefox 11, Internet Explorer 7 and Internet Explorer 8.

cc_dashboard does not render correctly using Internet Explorer 6 and I have no intention of supporting IE6 :)

# Libraries

A lot of the functionality of this build monitor would not be possible if not for the awesome efforts of others. Here are some of the javascript libraries used by this application:

* Alarm times natural language date parsing is done by [chrono](https://github.com/berryboy/chrono)
* Alarm text-to-speech is made possible by [speak.js](https://github.com/kripken/speak.js)
* Code coverage graphs enabled by [Highcharts](http://www.highcharts.com/)

# License and Acknowledgements

cc_dashboard is licensed under the terms of the the Apache 2.0 license. See [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0) for details.

Some of the images used for the skins have their own licenses - see below.

## Skins

The 'doom' skin images are copyright [id Software](http://www.idsoftware.com/). Special thanks to Phidias N. Bourlas for generating the
[original animated GIFs](http://www.cslab.ntua.gr/~phib/doom1.htm) that were used to create the skin.

The 'hudson' skin images are copied from the [Hudson continuous integration server](https://hudson.dev.java.net/), which copied most of its art work from [Tango Project](http://tango.freedesktop.org/Tango_Desktop_Project).

The 'smiley' skin favicons are derived from images from [Tango Project](http://tango.freedesktop.org/Tango_Desktop_Project), which are
covered by the [Creative Commons Attribution Share-Alike License](http://creativecommons.org/licenses/by-sa/2.5/).

The 'spaceinvaders' images are derived from those on [The History Of Space Invaders](http://www.brentradio.com/SpaceInvaders.htm).
Space Invaders copyright Taito Corp.

The 'worldcup' skin was contributed by [lightningdb](http://github.com/lightningdb)

## Bling

The 'cheezburger' images are copyright Pet Holdings, Inc. The technique to get around browser security issues when AJAX loading the images was lifted from... inspired by Kevin Luck's blog post [Data Scraping with YQL and JQuery](http://www.kelvinluck.com/2009/02/data-scraping-with-yql-and-jquery/). Thanks also to Yahoo! for providing [YQL](http://developer.yahoo.com/yql/), a nice tool that makes screen scraping dead easy.

The 'chucknorris' bling was inspired by the [Hudson Chuck Norris Plugin](http://wiki.hudson-ci.org/display/HUDSON/ChuckNorris+Plugin),
which in turn was inspired by [The Ultimate Top 25 Chuck Norris 'The Programmer' Jokes](http://www.codesqueeze.com/the-ultimate-top-25-chuck-norris-the-programmer-jokes/). (Which I think was in turn inspired by [ChuckNorrisFacts.com](http://chucknorrisfacts.com/).)

## (Sound) Tracks

The 'aliens' sound bites are copyright 20th Century Fox (1986).

The 'simpsons' sound bites are copyright Fox.

## Alarms

'24' is copyright 20th Century Fox Television.

The '24' countdown-clock-like [LCD font](http://www.dafont.com/lcd-lcd-mono.font) was created by [Samuel Reynolds](http://www.spinwardstars.com/scrfonts/).

# Other CruiseControl Aggregators

[big-visible-cruise-web](http://code.google.com/p/big-visible-cuise-web/) is Java servlet/Javascript webapp which remembers which builds you chose to show/hide.

[bigvisiblewall](http://code.google.com/p/bigvisiblewall/) is implemented in Scala and packaged as a Java web application.

[cc_board](http://github.com/qxjit/cc_board) is a [Sinatra-based](http://www.sinatrarb.com/) aggregator.

[cc_monitor](http://github.com/betarelease/cc_monitor) is a [Ramaze-based](http://ramaze.net/) aggregator. This was the main inspiration for cc_dashboard, but was not very robust at the time.
