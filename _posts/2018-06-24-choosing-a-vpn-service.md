---
layout: post
title: Choosing a VPN service
---

Net Neutrality is officially [over in the US](https://www.bbc.com/news/technology-44438812). As the [EFF notes](https://www.eff.org/deeplinks/2018/06/bleak-future-internet-without-net-neutrality-and-what-you-can-do-stop-it), it will likely manifest as a slow, painful decline of the Internet. We can [call congress](https://act.eff.org/action/tell-congress-to-reinstate-the-open-internet-order/) to demand that they reverse the decision and act in the interests of the people. But whether or not that succeeds, everyone should be using a VPN regularly now to fight against the growing threats of Internet surveillance and censorship. We know better than to trust corporations and governments.

<!--excerpt-->

There is some hope for Net Neutrality regulations at the state level. Several states are crafting legislation of their own. However, it is looking increasingly grim, at least in California where [S.B. 822 is being gutted](https://www.eff.org/deeplinks/2018/06/rampant-corruption-assembly-committee-gutted-californias-net-neutrality) by the politicians that are owned by the telecoms. But aside from all this, there is also the [repeal of the broadband privacy rules](https://www.eff.org/deeplinks/2017/05/congress-repealing-our-internet-privacy-rights-meant-congress-repealed-internet). It is also terrible, effectively allowing ISPs to spy on your Internet activity.

### What to consider for a VPN service

Choosing a VPN is a big decision. You are choosing to funnel all your traffic through another company's servers. Who can you trust? (No one!) That question is probably better phrased as *who seems the most trustworthy, given the company's history, the jurisdiction in which they operate, their business model, the logs/data they collect, and their incentives to protect your privacy*?

For example, I would *never* use Onavo, which is [owned by Facebook](https://techcrunch.com/2018/02/12/facebook-starts-pushing-its-data-tracking-onavo-vpn-within-its-main-mobile-app/) and [sends your mobile usage and data traffic](https://mjtsai.com/blog/2018/02/15/facebooks-protect-feature/) to graph.facebook.com. Why does a VPN service need tell Facebook when your device screen is turned on and off? And we knew that *before* the Cambridge Analytica mess. I mean, holy shit. But even if we didn't know this and even if Cambridge Analytica hadn't happened, what incentive would Onavo have to protect your privacy when it's owned by a company like Facebook? But I digress.

Another popular service is TunnelBear, which has an admittedly cute logo. Those adorable bears crawling through tunnels lured me in. Who doesn't appreciate that metaphor? Unfortunately, they [collect more metadata than I'd like](https://www.tunnelbear.com/privacy-policy), block all P2P traffic (because Canada), and were [acquired by McAfee](https://techcrunch.com/2018/03/08/mcafee-acquires-vpn-company-tunnelbear/) earlier this year. Whether you agree or disagree with file sharing, any kind of explicit blocking from a VPN service is a red flag for me. And in general, I don't feel comfortable with a VPN who's jurisdiction is in [the Five Eyes](https://en.wikipedia.org/wiki/Five_Eyes) (or the [Nine or Fourteen Eyes](https://www.privacytools.io/#ukusa)).

Some questions to consider:

- What data do they collect about users?
- What do they log and how long do they keep logs?
- What jurisdiction do they operate in? Do they avoid the Five Eyes?
- Do they support [OpenVPN](https://en.wikipedia.org/wiki/OpenVPN)?
- Is personal information required to create an account?
- Do they engage in port blocking?
- Do they offer strong encryption by default?

### Resources for learning about VPNs

[ThatOnePrivacySite.net](https://thatoneprivacysite.net) has a [detailed VPN comparison chart](https://thatoneprivacysite.net/vpn-comparison-chart/) where you can see nearly anything you'd like to know about 185 different VPNs, as well as an [in-depth guide for choosing one](https://thatoneprivacysite.net/choosing-the-best-vpn-for-you/). [PrivacyTools.io](https://www.privacytools.io) offers a list of recommended VPNs, among other excellent privacy resources. TorrentFreak publishes a [yearly VPN review](https://torrentfreak.com/vpn-services-keep-anonymous-2018/), in which providers are asked to respond to a number of questions about their services, operating jurisdiction, logging policies, and more. Those are great places to start to determine what service is best for you.

### NordVPN

I've been using [NordVPN](https://nordvpn.com) for a couple of years now. They check most of the important boxes for me regarding security, ease-of-use, and affordability. They have a clear [Terms of Service](https://nordvpn.com/terms-of-service/) and a strict no-logs policy. They are recommended by [PrivacyTools.io](https://www.privacytools.io/#vpn). They operate under the jurisdiction of Panama, a country with a reputation for not giving a shit. Being associated with Panama is not something you would look for [in a politician](https://en.wikipedia.org/wiki/List_of_people_named_in_the_Panama_Papers), but for a VPN service? Probably for the best. (Again, avoiding [the Fourteen Eyes](https://www.privacytools.io/#ukusa) is the main priority.)

Nord has a good set of features, strong encryption by default, an extensive list of servers to choose, excellent macOS and iOS client apps, and reasonably priced plans. They are not perfect however (no VPN is!), and you can see their shortcomings on the [VPN comparison chart](https://thatoneprivacysite.net/vpn-comparison-chart/) and their [interview with TorrentFreak](https://torrentfreak.com/vpn-services-keep-anonymous-2018/). However, these trade-offs are acceptable to me for now. What's important is staying informed about your current VPN provider and making sure the things you care about most aren't changing &mdash; like getting acquired by Facebook or McAfee.
