Section II. HTML based scraping (1 hour)

- GET and POST calls to retrieve response objects - using urllib2, requests, JSON etc
- Using bs4 (and lxml) to parse the structure and access different elements within a HTML or XML
- Manipulate it into a tabular structure - explore the schema
- Store it in the appropriate format - CSV, TSV and export the results

## 1. GET and POST calls to retrieve response objects - using urllib2, requests, JSON etc



```python
import requests
import pandas as pd
from bs4 import BeautifulSoup

web_url = 'https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018'
res = requests.get(web_url)
```

## 2. Using bs4 (and lxml) to parse the structure and access different elements within a HTML or XML


```python
soup_object = BeautifulSoup(res.content)
```

## 3. Manipulate it into a tabular structure - explore the schema


```python
data_table = soup_object.find_all('table', 'data-table')[0]
```


```python
all_values = data_table.find_all('tr')
all_values
```




    [<tr><th>Rank</th>
     <th>Company</th>
     <th>Website</th>
     </tr>, <tr><td>1</td>
     <td>Walmart</td>
     <td><a href="http://www.stock.walmart.com">http://www.stock.walmart.com</a></td>
     </tr>, <tr><td>2</td>
     <td>Exxon Mobil</td>
     <td><a href="http://www.exxonmobil.com">http://www.exxonmobil.com</a></td>
     </tr>, <tr><td>3</td>
     <td>Berkshire Hathaway</td>
     <td><a href="http://www.berkshirehathaway.com">http://www.berkshirehathaway.com</a></td>
     </tr>, <tr><td>4</td>
     <td>Apple</td>
     <td><a href="http://www.apple.com">http://www.apple.com</a></td>
     </tr>, <tr><td>5</td>
     <td>UnitedHealth Group</td>
     <td><a href="http://www.unitedhealthgroup.com">http://www.unitedhealthgroup.com</a></td>
     </tr>, <tr><td>6</td>
     <td>McKesson</td>
     <td><a href="http://www.mckesson.com">http://www.mckesson.com</a></td>
     </tr>, <tr><td>7</td>
     <td>CVS Health</td>
     <td><a href="http://www.cvshealth.com">http://www.cvshealth.com</a></td>
     </tr>, <tr><td>8</td>
     <td>Amazon.com</td>
     <td><a href="http://www.amazon.com">http://www.amazon.com</a></td>
     </tr>, <tr><td>9</td>
     <td>AT&amp;T</td>
     <td><a href="http://www.att.com">http://www.att.com</a></td>
     </tr>, <tr><td>10</td>
     <td>General Motors</td>
     <td><a href="http://www.gm.com">http://www.gm.com</a></td>
     </tr>, <tr><td>11</td>
     <td>Ford Motor</td>
     <td><a href="http://www.corporate.ford.com">http://www.corporate.ford.com</a></td>
     </tr>, <tr><td>12</td>
     <td>AmerisourceBergen</td>
     <td><a href="http://www.amerisourcebergen.com">http://www.amerisourcebergen.com</a></td>
     </tr>, <tr><td>13</td>
     <td>Chevron</td>
     <td><a href="http://www.chevron.com">http://www.chevron.com</a></td>
     </tr>, <tr><td>14</td>
     <td>Cardinal Health</td>
     <td><a href="http://www.cardinalhealth.com">http://www.cardinalhealth.com</a></td>
     </tr>, <tr><td>15</td>
     <td>Costco</td>
     <td><a href="http://www.costco.com">http://www.costco.com</a></td>
     </tr>, <tr><td>16</td>
     <td>Verizon</td>
     <td><a href="http://www.verizon.com">http://www.verizon.com</a></td>
     </tr>, <tr><td>17</td>
     <td>Kroger</td>
     <td><a href="http://www.thekrogerco.com">http://www.thekrogerco.com</a></td>
     </tr>, <tr><td>18</td>
     <td>General Electric</td>
     <td><a href="http://www.ge.com">http://www.ge.com</a></td>
     </tr>, <tr><td>19</td>
     <td>Walgreens Boots Alliance</td>
     <td><a href="http://www.walgreensbootsalliance.com">http://www.walgreensbootsalliance.com</a></td>
     </tr>, <tr><td>20</td>
     <td>JPMorgan Chase</td>
     <td><a href="http://www.jpmorganchase.com">http://www.jpmorganchase.com</a></td>
     </tr>, <tr><td>21</td>
     <td>Fannie Mae</td>
     <td><a href="http://www.fanniemae.com">http://www.fanniemae.com</a></td>
     </tr>, <tr><td>22</td>
     <td>Alphabet</td>
     <td><a href="http://www.abc.xyz">http://www.abc.xyz</a></td>
     </tr>, <tr><td>23</td>
     <td>Home Depot</td>
     <td><a href="http://www.homedepot.com">http://www.homedepot.com</a></td>
     </tr>, <tr><td>24</td>
     <td>Bank of America Corp.</td>
     <td><a href="http://www.bankofamerica.com">http://www.bankofamerica.com</a></td>
     </tr>, <tr><td>25</td>
     <td>Express Scripts Holding</td>
     <td><a href="http://www.express-scripts.com">http://www.express-scripts.com</a></td>
     </tr>, <tr><td>26</td>
     <td>Wells Fargo</td>
     <td><a href="http://www.wellsfargo.com">http://www.wellsfargo.com</a></td>
     </tr>, <tr><td>27</td>
     <td>Boeing</td>
     <td><a href="http://www.boeing.com">http://www.boeing.com</a></td>
     </tr>, <tr><td>28</td>
     <td>Phillips</td>
     <td><a href="http://www.phillips66.com">http://www.phillips66.com</a></td>
     </tr>, <tr><td>29</td>
     <td>Anthem</td>
     <td><a href="http://www.antheminc.com">http://www.antheminc.com</a></td>
     </tr>, <tr><td>30</td>
     <td>Microsoft</td>
     <td><a href="http://www.microsoft.com">http://www.microsoft.com</a></td>
     </tr>, <tr><td>31</td>
     <td>Valero Energy</td>
     <td><a href="http://www.valero.com">http://www.valero.com</a></td>
     </tr>, <tr><td>32</td>
     <td>Citigroup</td>
     <td><a href="http://www.citigroup.com">http://www.citigroup.com</a></td>
     </tr>, <tr><td>33</td>
     <td>Comcast</td>
     <td><a href="http://www.comcastcorporation.com">http://www.comcastcorporation.com</a></td>
     </tr>, <tr><td>34</td>
     <td>IBM</td>
     <td><a href="http://www.ibm.com">http://www.ibm.com</a></td>
     </tr>, <tr><td>35</td>
     <td>Dell Technologies</td>
     <td><a href="http://www.delltechnologies.com">http://www.delltechnologies.com</a></td>
     </tr>, <tr><td>36</td>
     <td>State Farm Insurance Cos.</td>
     <td><a href="http://www.statefarm.com">http://www.statefarm.com</a></td>
     </tr>, <tr><td>37</td>
     <td>Johnson &amp; Johnson</td>
     <td><a href="http://www.jnj.com">http://www.jnj.com</a></td>
     </tr>, <tr><td>38</td>
     <td>Freddie Mac</td>
     <td><a href="http://www.freddiemac.com">http://www.freddiemac.com</a></td>
     </tr>, <tr><td>39</td>
     <td>Target</td>
     <td><a href="http://www.target.com">http://www.target.com</a></td>
     </tr>, <tr><td>40</td>
     <td>Lowe’s</td>
     <td><a href="http://www.lowes.com">http://www.lowes.com</a></td>
     </tr>, <tr><td>41</td>
     <td>Marathon Petroleum</td>
     <td><a href="http://www.marathonpetroleum.com">http://www.marathonpetroleum.com</a></td>
     </tr>, <tr><td>42</td>
     <td>Procter &amp; Gamble</td>
     <td><a href="http://www.pg.com">http://www.pg.com</a></td>
     </tr>, <tr><td>43</td>
     <td>MetLife</td>
     <td><a href="http://www.metlife.com">http://www.metlife.com</a></td>
     </tr>, <tr><td>44</td>
     <td>UPS</td>
     <td><a href="http://www.ups.com">http://www.ups.com</a></td>
     </tr>, <tr><td>45</td>
     <td>PepsiCo</td>
     <td><a href="http://www.pepsico.com">http://www.pepsico.com</a></td>
     </tr>, <tr><td>46</td>
     <td>Intel</td>
     <td><a href="http://www.intel.com">http://www.intel.com</a></td>
     </tr>, <tr><td>47</td>
     <td>DowDuPont</td>
     <td><a href="www.dow-dupont.com">www.dow-dupont.com</a></td>
     </tr>, <tr><td>48</td>
     <td>Archer Daniels Midland</td>
     <td><a href="http://www.adm.com">http://www.adm.com</a></td>
     </tr>, <tr><td>49</td>
     <td>Aetna</td>
     <td><a href="http://www.aetna.com">http://www.aetna.com</a></td>
     </tr>, <tr><td>50</td>
     <td>FedEx</td>
     <td><a href="http://www.fedex.com">http://www.fedex.com</a></td>
     </tr>, <tr><td>51</td>
     <td>United Technologies</td>
     <td><a href="http://www.utc.com">http://www.utc.com</a></td>
     </tr>, <tr><td>52</td>
     <td>Prudential Financial</td>
     <td><a href="http://www.prudential.com">http://www.prudential.com</a></td>
     </tr>, <tr><td>53</td>
     <td>Albertsons Cos.</td>
     <td><a href="http://www.albertsons.com">http://www.albertsons.com</a></td>
     </tr>, <tr><td>54</td>
     <td>Sysco</td>
     <td><a href="http://www.sysco.com">http://www.sysco.com</a></td>
     </tr>, <tr><td>55</td>
     <td>Disney</td>
     <td><a href="http://www.disney.com">http://www.disney.com</a></td>
     </tr>, <tr><td>56</td>
     <td>Humana</td>
     <td><a href="http://www.humana.com">http://www.humana.com</a></td>
     </tr>, <tr><td>57</td>
     <td>Pfizer</td>
     <td><a href="http://www.pfizer.com">http://www.pfizer.com</a></td>
     </tr>, <tr><td>58</td>
     <td>HP</td>
     <td><a href="http://www.hp.com">http://www.hp.com</a></td>
     </tr>, <tr><td>59</td>
     <td>Lockheed Martin</td>
     <td><a href="http://www.lockheedmartin.com">http://www.lockheedmartin.com</a></td>
     </tr>, <tr><td>60</td>
     <td>AIG</td>
     <td><a href="http://www.aig.com">http://www.aig.com</a></td>
     </tr>, <tr><td>61</td>
     <td>Centene</td>
     <td><a href="http://www.centene.com">http://www.centene.com</a></td>
     </tr>, <tr><td>62</td>
     <td>Cisco Systems</td>
     <td><a href="http://www.cisco.com">http://www.cisco.com</a></td>
     </tr>, <tr><td>63</td>
     <td>HCA Healthcare</td>
     <td><a href="www.hcahealthcare.com">www.hcahealthcare.com</a></td>
     </tr>, <tr><td>64</td>
     <td>Energy Transfer Equity</td>
     <td><a href="http://www.energytransfer.com">http://www.energytransfer.com</a></td>
     </tr>, <tr><td>65</td>
     <td>Caterpillar</td>
     <td><a href="http://www.caterpillar.com">http://www.caterpillar.com</a></td>
     </tr>, <tr><td>66</td>
     <td>Nationwide</td>
     <td><a href="http://www.nationwide.com">http://www.nationwide.com</a></td>
     </tr>, <tr><td>67</td>
     <td>Morgan Stanley</td>
     <td><a href="http://www.morganstanley.com">http://www.morganstanley.com</a></td>
     </tr>, <tr><td>68</td>
     <td>Liberty Mutual Insurance Group</td>
     <td><a href="http://www.libertymutual.com">http://www.libertymutual.com</a></td>
     </tr>, <tr><td>69</td>
     <td>New York Life Insurance</td>
     <td><a href="http://www.newyorklife.com">http://www.newyorklife.com</a></td>
     </tr>, <tr><td>70</td>
     <td>Goldman Sachs Group</td>
     <td><a href="http://www.gs.com">http://www.gs.com</a></td>
     </tr>, <tr><td>71</td>
     <td>American Airlines Group</td>
     <td><a href="http://www.aa.com">http://www.aa.com</a></td>
     </tr>, <tr><td>72</td>
     <td>Best Buy</td>
     <td><a href="http://www.bestbuy.com">http://www.bestbuy.com</a></td>
     </tr>, <tr><td>73</td>
     <td>Cigna</td>
     <td><a href="http://www.cigna.com">http://www.cigna.com</a></td>
     </tr>, <tr><td>74</td>
     <td>Charter Communications</td>
     <td><a href="http://www.charter.com">http://www.charter.com</a></td>
     </tr>, <tr><td>75</td>
     <td>Delta Air Lines</td>
     <td><a href="http://www.delta.com">http://www.delta.com</a></td>
     </tr>, <tr><td>76</td>
     <td>Facebook</td>
     <td><a href="http://www.facebook.com">http://www.facebook.com</a></td>
     </tr>, <tr><td>77</td>
     <td>Honeywell International</td>
     <td><a href="http://www.honeywell.com">http://www.honeywell.com</a></td>
     </tr>, <tr><td>78</td>
     <td>Merck</td>
     <td><a href="http://www.merck.com">http://www.merck.com</a></td>
     </tr>, <tr><td>79</td>
     <td>Allstate</td>
     <td><a href="http://www.allstate.com">http://www.allstate.com</a></td>
     </tr>, <tr><td>80</td>
     <td>Tyson Foods</td>
     <td><a href="http://www.tysonfoods.com">http://www.tysonfoods.com</a></td>
     </tr>, <tr><td>81</td>
     <td>United Continental Holdings</td>
     <td><a href="http://www.united.com">http://www.united.com</a></td>
     </tr>, <tr><td>82</td>
     <td>Oracle</td>
     <td><a href="http://www.oracle.com">http://www.oracle.com</a></td>
     </tr>, <tr><td>83</td>
     <td>Tech Data</td>
     <td><a href="http://www.techdata.com">http://www.techdata.com</a></td>
     </tr>, <tr><td>84</td>
     <td>TIAA</td>
     <td><a href="http://www.tiaa.org">http://www.tiaa.org</a></td>
     </tr>, <tr><td>85</td>
     <td>TJX</td>
     <td><a href="http://www.tjx.com">http://www.tjx.com</a></td>
     </tr>, <tr><td>86</td>
     <td>American Express</td>
     <td><a href="http://www.americanexpress.com">http://www.americanexpress.com</a></td>
     </tr>, <tr><td>87</td>
     <td>Coca-Cola</td>
     <td><a href="http://www.coca-colacompany.com">http://www.coca-colacompany.com</a></td>
     </tr>, <tr><td>88</td>
     <td>Publix Super Markets</td>
     <td><a href="http://www.publix.com">http://www.publix.com</a></td>
     </tr>, <tr><td>89</td>
     <td>Nike</td>
     <td><a href="http://www.nike.com">http://www.nike.com</a></td>
     </tr>, <tr><td>90</td>
     <td>Andeavor</td>
     <td><a href="www.andeavor.com">www.andeavor.com</a></td>
     </tr>, <tr><td>91</td>
     <td>World Fuel Services</td>
     <td><a href="http://www.wfscorp.com">http://www.wfscorp.com</a></td>
     </tr>, <tr><td>92</td>
     <td>Exelon</td>
     <td><a href="http://www.exeloncorp.com">http://www.exeloncorp.com</a></td>
     </tr>, <tr><td>93</td>
     <td>Massachusetts Mutual Life Insurance</td>
     <td><a href="http://www.massmutual.com">http://www.massmutual.com</a></td>
     </tr>, <tr><td>94</td>
     <td>Rite Aid</td>
     <td><a href="http://www.riteaid.com">http://www.riteaid.com</a></td>
     </tr>, <tr><td>95</td>
     <td>ConocoPhillips</td>
     <td><a href="http://www.conocophillips.com">http://www.conocophillips.com</a></td>
     </tr>, <tr><td>96</td>
     <td>CHS</td>
     <td><a href="http://www.chsinc.com">http://www.chsinc.com</a></td>
     </tr>, <tr><td>97</td>
     <td>M</td>
     <td><a href="http://www.3m.com">http://www.3m.com</a></td>
     </tr>, <tr><td>98</td>
     <td>Time Warner</td>
     <td><a href="http://www.timewarner.com">http://www.timewarner.com</a></td>
     </tr>, <tr><td>99</td>
     <td>General Dynamics</td>
     <td><a href="http://www.generaldynamics.com">http://www.generaldynamics.com</a></td>
     </tr>, <tr><td>100</td>
     <td>USAA</td>
     <td><a href="http://www.usaa.com">http://www.usaa.com</a></td>
     </tr>, <tr><td>101</td>
     <td>Capital One Financial</td>
     <td><a href="http://www.capitalone.com">http://www.capitalone.com</a></td>
     </tr>, <tr><td>102</td>
     <td>Deere</td>
     <td><a href="http://www.johndeere.com">http://www.johndeere.com</a></td>
     </tr>, <tr><td>103</td>
     <td>INTL FCStone</td>
     <td><a href="http://www.intlfcstone.com">http://www.intlfcstone.com</a></td>
     </tr>, <tr><td>104</td>
     <td>Northwestern Mutual</td>
     <td><a href="http://www.northwesternmutual.com">http://www.northwesternmutual.com</a></td>
     </tr>, <tr><td>105</td>
     <td>Enterprise Products Partners</td>
     <td><a href="http://www.enterpriseproducts.com">http://www.enterpriseproducts.com</a></td>
     </tr>, <tr><td>106</td>
     <td>Travelers Cos.</td>
     <td><a href="http://www.travelers.com">http://www.travelers.com</a></td>
     </tr>, <tr><td>107</td>
     <td>Hewlett Packard Enterprise</td>
     <td><a href="http://www.hpe.com">http://www.hpe.com</a></td>
     </tr>, <tr><td>108</td>
     <td>Philip Morris International</td>
     <td><a href="http://www.pmi.com">http://www.pmi.com</a></td>
     </tr>, <tr><td>109</td>
     <td>Twenty-First Century Fox</td>
     <td><a href="http://www.21cf.com">http://www.21cf.com</a></td>
     </tr>, <tr><td>110</td>
     <td>AbbVie</td>
     <td><a href="http://www.abbvie.com">http://www.abbvie.com</a></td>
     </tr>, <tr><td>111</td>
     <td>Abbott Laboratories</td>
     <td><a href="http://www.abbott.com">http://www.abbott.com</a></td>
     </tr>, <tr><td>112</td>
     <td>Progressive</td>
     <td><a href="http://www.progressive.com">http://www.progressive.com</a></td>
     </tr>, <tr><td>113</td>
     <td>Arrow Electronics</td>
     <td><a href="http://www.arrow.com">http://www.arrow.com</a></td>
     </tr>, <tr><td>114</td>
     <td>Kraft Heinz</td>
     <td><a href="http://www.kraftheinzcompany.com">http://www.kraftheinzcompany.com</a></td>
     </tr>, <tr><td>115</td>
     <td>Plains GP Holdings</td>
     <td><a href="http://www.plainsallamerican.com">http://www.plainsallamerican.com</a></td>
     </tr>, <tr><td>116</td>
     <td>Gilead Sciences</td>
     <td><a href="http://www.gilead.com">http://www.gilead.com</a></td>
     </tr>, <tr><td>117</td>
     <td>Mondelez International</td>
     <td><a href="http://www.mondelezinternational.com">http://www.mondelezinternational.com</a></td>
     </tr>, <tr><td>118</td>
     <td>Northrop Grumman</td>
     <td><a href="http://www.northropgrumman.com">http://www.northropgrumman.com</a></td>
     </tr>, <tr><td>119</td>
     <td>Raytheon</td>
     <td><a href="http://www.raytheon.com">http://www.raytheon.com</a></td>
     </tr>, <tr><td>120</td>
     <td>Macy’s</td>
     <td><a href="http://www.macysinc.com">http://www.macysinc.com</a></td>
     </tr>, <tr><td>121</td>
     <td>US Foods Holding</td>
     <td><a href="http://www.usfoods.com">http://www.usfoods.com</a></td>
     </tr>, <tr><td>122</td>
     <td>U.S. Bancorp</td>
     <td><a href="http://www.usbank.com">http://www.usbank.com</a></td>
     </tr>, <tr><td>123</td>
     <td>Dollar General</td>
     <td><a href="http://www.dollargeneral.com">http://www.dollargeneral.com</a></td>
     </tr>, <tr><td>124</td>
     <td>International Paper</td>
     <td><a href="http://www.internationalpaper.com">http://www.internationalpaper.com</a></td>
     </tr>, <tr><td>125</td>
     <td>Duke Energy</td>
     <td><a href="http://www.duke-energy.com">http://www.duke-energy.com</a></td>
     </tr>, <tr><td>126</td>
     <td>Southern</td>
     <td><a href="http://www.southerncompany.com">http://www.southerncompany.com</a></td>
     </tr>, <tr><td>127</td>
     <td>Marriott International</td>
     <td><a href="http://www.marriott.com">http://www.marriott.com</a></td>
     </tr>, <tr><td>128</td>
     <td>Avnet</td>
     <td><a href="http://www.avnet.com">http://www.avnet.com</a></td>
     </tr>, <tr><td>129</td>
     <td>Eli Lilly</td>
     <td><a href="http://www.lilly.com">http://www.lilly.com</a></td>
     </tr>, <tr><td>130</td>
     <td>Amgen</td>
     <td><a href="http://www.amgen.com">http://www.amgen.com</a></td>
     </tr>, <tr><td>131</td>
     <td>McDonald’s</td>
     <td><a href="http://www.aboutmcdonalds.com">http://www.aboutmcdonalds.com</a></td>
     </tr>, <tr><td>132</td>
     <td>Starbucks</td>
     <td><a href="http://www.starbucks.com">http://www.starbucks.com</a></td>
     </tr>, <tr><td>133</td>
     <td>Qualcomm</td>
     <td><a href="http://www.qualcomm.com">http://www.qualcomm.com</a></td>
     </tr>, <tr><td>134</td>
     <td>Dollar Tree</td>
     <td><a href="http://www.dollartree.com">http://www.dollartree.com</a></td>
     </tr>, <tr><td>135</td>
     <td>PBF Energy</td>
     <td><a href="http://www.pbfenergy.com">http://www.pbfenergy.com</a></td>
     </tr>, <tr><td>136</td>
     <td>Icahn Enterprises</td>
     <td><a href="http://www.ielp.com">http://www.ielp.com</a></td>
     </tr>, <tr><td>137</td>
     <td>Aflac</td>
     <td><a href="http://www.aflac.com">http://www.aflac.com</a></td>
     </tr>, <tr><td>138</td>
     <td>AutoNation</td>
     <td><a href="http://www.autonation.com">http://www.autonation.com</a></td>
     </tr>, <tr><td>139</td>
     <td>Penske Automotive Group</td>
     <td><a href="http://www.penskeautomotive.com">http://www.penskeautomotive.com</a></td>
     </tr>, <tr><td>140</td>
     <td>Whirlpool</td>
     <td><a href="http://www.whirlpoolcorp.com">http://www.whirlpoolcorp.com</a></td>
     </tr>, <tr><td>141</td>
     <td>Union Pacific</td>
     <td><a href="http://www.up.com">http://www.up.com</a></td>
     </tr>, <tr><td>142</td>
     <td>Southwest Airlines</td>
     <td><a href="http://www.southwest.com">http://www.southwest.com</a></td>
     </tr>, <tr><td>143</td>
     <td>ManpowerGroup</td>
     <td><a href="http://www.manpowergroup.com">http://www.manpowergroup.com</a></td>
     </tr>, <tr><td>144</td>
     <td>Thermo Fisher Scientific</td>
     <td><a href="http://www.thermofisher.com">http://www.thermofisher.com</a></td>
     </tr>, <tr><td>145</td>
     <td>Bristol-Myers Squibb</td>
     <td><a href="http://www.bms.com">http://www.bms.com</a></td>
     </tr>, <tr><td>146</td>
     <td>Halliburton</td>
     <td><a href="http://www.halliburton.com">http://www.halliburton.com</a></td>
     </tr>, <tr><td>147</td>
     <td>Tenet Healthcare</td>
     <td><a href="http://www.tenethealth.com">http://www.tenethealth.com</a></td>
     </tr>, <tr><td>148</td>
     <td>Lear</td>
     <td><a href="http://www.lear.com">http://www.lear.com</a></td>
     </tr>, <tr><td>149</td>
     <td>Cummins</td>
     <td><a href="http://www.cummins.com">http://www.cummins.com</a></td>
     </tr>, <tr><td>150</td>
     <td>Micron Technology</td>
     <td><a href="http://www.micron.com">http://www.micron.com</a></td>
     </tr>, <tr><td>151</td>
     <td>Nucor</td>
     <td><a href="http://www.nucor.com">http://www.nucor.com</a></td>
     </tr>, <tr><td>152</td>
     <td>Molina Healthcare</td>
     <td><a href="http://www.molinahealthcare.com">http://www.molinahealthcare.com</a></td>
     </tr>, <tr><td>153</td>
     <td>Fluor</td>
     <td><a href="http://www.fluor.com">http://www.fluor.com</a></td>
     </tr>, <tr><td>154</td>
     <td>Altria Group</td>
     <td><a href="http://www.altria.com">http://www.altria.com</a></td>
     </tr>, <tr><td>155</td>
     <td>Paccar</td>
     <td><a href="http://www.paccar.com">http://www.paccar.com</a></td>
     </tr>, <tr><td>156</td>
     <td>Hartford Financial Services</td>
     <td><a href="http://www.thehartford.com">http://www.thehartford.com</a></td>
     </tr>, <tr><td>157</td>
     <td>Kohl’s</td>
     <td><a href="http://www.kohls.com">http://www.kohls.com</a></td>
     </tr>, <tr><td>158</td>
     <td>Western Digital</td>
     <td><a href="http://www.wdc.com">http://www.wdc.com</a></td>
     </tr>, <tr><td>159</td>
     <td>Jabil</td>
     <td><a href="www.jabil.com">www.jabil.com</a></td>
     </tr>, <tr><td>160</td>
     <td>Community Health Systems</td>
     <td><a href="http://www.chs.net">http://www.chs.net</a></td>
     </tr>, <tr><td>161</td>
     <td>Visa</td>
     <td><a href="http://www.visa.com">http://www.visa.com</a></td>
     </tr>, <tr><td>162</td>
     <td>Danaher</td>
     <td><a href="http://www.danaher.com">http://www.danaher.com</a></td>
     </tr>, <tr><td>163</td>
     <td>Kimberly-Clark</td>
     <td><a href="http://www.kimberly-clark.com">http://www.kimberly-clark.com</a></td>
     </tr>, <tr><td>164</td>
     <td>AECOM</td>
     <td><a href="http://www.aecom.com">http://www.aecom.com</a></td>
     </tr>, <tr><td>165</td>
     <td>PNC Financial Services</td>
     <td><a href="http://www.pnc.com">http://www.pnc.com</a></td>
     </tr>, <tr><td>166</td>
     <td>CenturyLink</td>
     <td><a href="http://www.centurylink.com">http://www.centurylink.com</a></td>
     </tr>, <tr><td>167</td>
     <td>NextEra Energy</td>
     <td><a href="http://www.nexteraenergy.com">http://www.nexteraenergy.com</a></td>
     </tr>, <tr><td>168</td>
     <td>PG&amp;E Corp.</td>
     <td><a href="http://www.pgecorp.com">http://www.pgecorp.com</a></td>
     </tr>, <tr><td>169</td>
     <td>Synnex</td>
     <td><a href="http://www.synnex.com">http://www.synnex.com</a></td>
     </tr>, <tr><td>170</td>
     <td>WellCare Health Plans</td>
     <td><a href="http://www.wellcare.com">http://www.wellcare.com</a></td>
     </tr>, <tr><td>171</td>
     <td>Performance Food Group</td>
     <td><a href="http://www.pfgc.com">http://www.pfgc.com</a></td>
     </tr>, <tr><td>172</td>
     <td>Sears Holdings</td>
     <td><a href="http://www.searsholdings.com">http://www.searsholdings.com</a></td>
     </tr>, <tr><td>173</td>
     <td>Synchrony Financial</td>
     <td><a href="http://www.synchronyfinancial.com">http://www.synchronyfinancial.com</a></td>
     </tr>, <tr><td>174</td>
     <td>CarMax</td>
     <td><a href="http://www.carmax.com">http://www.carmax.com</a></td>
     </tr>, <tr><td>175</td>
     <td>Bank of New York Mellon</td>
     <td><a href="www.bnymellon.com">www.bnymellon.com</a></td>
     </tr>, <tr><td>176</td>
     <td>Freeport-McMoRan</td>
     <td><a href="http://www.fcx.com">http://www.fcx.com</a></td>
     </tr>, <tr><td>177</td>
     <td>Genuine Parts</td>
     <td><a href="http://www.genpt.com">http://www.genpt.com</a></td>
     </tr>, <tr><td>178</td>
     <td>Emerson Electric</td>
     <td><a href="http://www.emerson.com">http://www.emerson.com</a></td>
     </tr>, <tr><td>179</td>
     <td>DaVita</td>
     <td><a href="http://www.davita.com">http://www.davita.com</a></td>
     </tr>, <tr><td>180</td>
     <td>Supervalu</td>
     <td><a href="http://www.supervalu.com">http://www.supervalu.com</a></td>
     </tr>, <tr><td>181</td>
     <td>Gap</td>
     <td><a href="http://www.gapinc.com">http://www.gapinc.com</a></td>
     </tr>, <tr><td>182</td>
     <td>General Mills</td>
     <td><a href="http://www.generalmills.com">http://www.generalmills.com</a></td>
     </tr>, <tr><td>183</td>
     <td>Nordstrom</td>
     <td><a href="http://www.nordstrom.com">http://www.nordstrom.com</a></td>
     </tr>, <tr><td>184</td>
     <td>Colgate-Palmolive</td>
     <td><a href="http://www.colgatepalmolive.com">http://www.colgatepalmolive.com</a></td>
     </tr>, <tr><td>185</td>
     <td>American Electric Power</td>
     <td><a href="http://www.aep.com">http://www.aep.com</a></td>
     </tr>, <tr><td>186</td>
     <td>XPO Logistics</td>
     <td><a href="http://www.xpo.com">http://www.xpo.com</a></td>
     </tr>, <tr><td>187</td>
     <td>Goodyear Tire &amp; Rubber</td>
     <td><a href="http://www.goodyear.com">http://www.goodyear.com</a></td>
     </tr>, <tr><td>188</td>
     <td>Omnicom Group</td>
     <td><a href="http://www.omnicomgroup.com">http://www.omnicomgroup.com</a></td>
     </tr>, <tr><td>189</td>
     <td>CDW</td>
     <td><a href="http://www.cdw.com">http://www.cdw.com</a></td>
     </tr>, <tr><td>190</td>
     <td>Sherwin-Williams</td>
     <td><a href="http://www.sherwin.com">http://www.sherwin.com</a></td>
     </tr>, <tr><td>191</td>
     <td>PPG Industries</td>
     <td><a href="http://www.ppg.com">http://www.ppg.com</a></td>
     </tr>, <tr><td>192</td>
     <td>Texas Instruments</td>
     <td><a href="http://www.ti.com">http://www.ti.com</a></td>
     </tr>, <tr><td>193</td>
     <td>C.H. Robinson Worldwide</td>
     <td><a href="http://www.chrobinson.com">http://www.chrobinson.com</a></td>
     </tr>, <tr><td>194</td>
     <td>WestRock</td>
     <td><a href="http://www.westrock.com">http://www.westrock.com</a></td>
     </tr>, <tr><td>195</td>
     <td>Cognizant Technology Solutions</td>
     <td><a href="http://www.cognizant.com">http://www.cognizant.com</a></td>
     </tr>, <tr><td>196</td>
     <td>Newell Brands</td>
     <td><a href="http://www.newellbrands.com">http://www.newellbrands.com</a></td>
     </tr>, <tr><td>197</td>
     <td>CBS</td>
     <td><a href="http://www.cbscorporation.com">http://www.cbscorporation.com</a></td>
     </tr>, <tr><td>198</td>
     <td>Envision Healthcare</td>
     <td><a href="http://www.evhc.net">http://www.evhc.net</a></td>
     </tr>, <tr><td>199</td>
     <td>Monsanto</td>
     <td><a href="http://www.monsanto.com">http://www.monsanto.com</a></td>
     </tr>, <tr><td>200</td>
     <td>Aramark</td>
     <td><a href="http://www.aramark.com">http://www.aramark.com</a></td>
     </tr>, <tr><td>201</td>
     <td>Applied Materials</td>
     <td><a href="http://www.appliedmaterials.com">http://www.appliedmaterials.com</a></td>
     </tr>, <tr><td>202</td>
     <td>Waste Management</td>
     <td><a href="http://www.wm.com">http://www.wm.com</a></td>
     </tr>, <tr><td>203</td>
     <td>DISH Network</td>
     <td><a href="http://www.dish.com">http://www.dish.com</a></td>
     </tr>, <tr><td>204</td>
     <td>Illinois Tool Works</td>
     <td><a href="http://www.itw.com">http://www.itw.com</a></td>
     </tr>, <tr><td>205</td>
     <td>Lincoln National</td>
     <td><a href="http://www.lfg.com">http://www.lfg.com</a></td>
     </tr>, <tr><td>206</td>
     <td>HollyFrontier</td>
     <td><a href="http://www.hollyfrontier.com">http://www.hollyfrontier.com</a></td>
     </tr>, <tr><td>207</td>
     <td>CBRE Group</td>
     <td><a href="http://www.cbre.com">http://www.cbre.com</a></td>
     </tr>, <tr><td>208</td>
     <td>Textron</td>
     <td><a href="http://www.textron.com">http://www.textron.com</a></td>
     </tr>, <tr><td>209</td>
     <td>Ross Stores</td>
     <td><a href="http://www.rossstores.com">http://www.rossstores.com</a></td>
     </tr>, <tr><td>210</td>
     <td>Principal Financial</td>
     <td><a href="http://www.principal.com">http://www.principal.com</a></td>
     </tr>, <tr><td>211</td>
     <td>D.R. Horton</td>
     <td><a href="http://www.drhorton.com">http://www.drhorton.com</a></td>
     </tr>, <tr><td>212</td>
     <td>Marsh &amp; McLennan</td>
     <td><a href="http://www.mmc.com">http://www.mmc.com</a></td>
     </tr>, <tr><td>213</td>
     <td>Devon Energy</td>
     <td><a href="http://www.devonenergy.com">http://www.devonenergy.com</a></td>
     </tr>, <tr><td>214</td>
     <td>AES</td>
     <td><a href="http://www.aes.com">http://www.aes.com</a></td>
     </tr>, <tr><td>215</td>
     <td>Ecolab</td>
     <td><a href="http://www.ecolab.com">http://www.ecolab.com</a></td>
     </tr>, <tr><td>216</td>
     <td>Land O’Lakes</td>
     <td><a href="http://www.landolakesinc.com">http://www.landolakesinc.com</a></td>
     </tr>, <tr><td>217</td>
     <td>Loews</td>
     <td><a href="http://www.loews.com">http://www.loews.com</a></td>
     </tr>, <tr><td>218</td>
     <td>Kinder Morgan</td>
     <td><a href="http://www.kindermorgan.com">http://www.kindermorgan.com</a></td>
     </tr>, <tr><td>219</td>
     <td>FirstEnergy</td>
     <td><a href="http://www.firstenergycorp.com">http://www.firstenergycorp.com</a></td>
     </tr>, <tr><td>220</td>
     <td>Occidental Petroleum</td>
     <td><a href="http://www.oxy.com">http://www.oxy.com</a></td>
     </tr>, <tr><td>221</td>
     <td>Viacom</td>
     <td><a href="http://www.viacom.com">http://www.viacom.com</a></td>
     </tr>, <tr><td>222</td>
     <td>PayPal Holdings</td>
     <td><a href="http://www.paypal.com">http://www.paypal.com</a></td>
     </tr>, <tr><td>223</td>
     <td>NGL Energy Partners</td>
     <td><a href="http://www.nglenergypartners.com">http://www.nglenergypartners.com</a></td>
     </tr>, <tr><td>224</td>
     <td>Celgene</td>
     <td><a href="http://www.celgene.com">http://www.celgene.com</a></td>
     </tr>, <tr><td>225</td>
     <td>Arconic</td>
     <td><a href="http://www.arconic.com">http://www.arconic.com</a></td>
     </tr>, <tr><td>226</td>
     <td>Kellogg</td>
     <td><a href="http://www.kelloggcompany.com">http://www.kelloggcompany.com</a></td>
     </tr>, <tr><td>227</td>
     <td>Las Vegas Sands</td>
     <td><a href="http://www.sands.com">http://www.sands.com</a></td>
     </tr>, <tr><td>228</td>
     <td>Stanley Black &amp; Decker</td>
     <td><a href="http://www.stanleyblackanddecker.com">http://www.stanleyblackanddecker.com</a></td>
     </tr>, <tr><td>229</td>
     <td>Booking Holdings</td>
     <td><a href="http://www.bookingholdings.com">http://www.bookingholdings.com</a></td>
     </tr>, <tr><td>230</td>
     <td>Lennar</td>
     <td><a href="http://www.lennar.com">http://www.lennar.com</a></td>
     </tr>, <tr><td>231</td>
     <td>L Brands</td>
     <td><a href="http://www.lb.com">http://www.lb.com</a></td>
     </tr>, <tr><td>232</td>
     <td>DTE Energy</td>
     <td><a href="http://www.dteenergy.com">http://www.dteenergy.com</a></td>
     </tr>, <tr><td>233</td>
     <td>Dominion Energy</td>
     <td><a href="www.dominionenergy.com">www.dominionenergy.com</a></td>
     </tr>, <tr><td>234</td>
     <td>Reinsurance Group of America</td>
     <td><a href="http://www.rgare.com">http://www.rgare.com</a></td>
     </tr>, <tr><td>235</td>
     <td>J.C. Penney</td>
     <td><a href="http://www.jcpenney.com">http://www.jcpenney.com</a></td>
     </tr>, <tr><td>236</td>
     <td>Mastercard</td>
     <td><a href="http://www.mastercard.com">http://www.mastercard.com</a></td>
     </tr>, <tr><td>237</td>
     <td>BlackRock</td>
     <td><a href="http://www.blackrock.com">http://www.blackrock.com</a></td>
     </tr>, <tr><td>238</td>
     <td>Henry Schein</td>
     <td><a href="http://www.henryschein.com">http://www.henryschein.com</a></td>
     </tr>, <tr><td>239</td>
     <td>Guardian Life Ins. Co. of America</td>
     <td><a href="http://www.guardianlife.com">http://www.guardianlife.com</a></td>
     </tr>, <tr><td>240</td>
     <td>Stryker</td>
     <td><a href="http://www.stryker.com">http://www.stryker.com</a></td>
     </tr>, <tr><td>241</td>
     <td>Jefferies Financial Group</td>
     <td><a href="http://www.jefferies.com">http://www.jefferies.com</a></td>
     </tr>, <tr><td>242</td>
     <td>VF</td>
     <td><a href="http://www.vfc.com">http://www.vfc.com</a></td>
     </tr>, <tr><td>243</td>
     <td>ADP</td>
     <td><a href="http://www.adp.com">http://www.adp.com</a></td>
     </tr>, <tr><td>244</td>
     <td>Edison International</td>
     <td><a href="http://www.edisoninvestor.com">http://www.edisoninvestor.com</a></td>
     </tr>, <tr><td>245</td>
     <td>Biogen</td>
     <td><a href="http://www.biogen.com">http://www.biogen.com</a></td>
     </tr>, <tr><td>246</td>
     <td>United States Steel</td>
     <td><a href="http://www.ussteel.com">http://www.ussteel.com</a></td>
     </tr>, <tr><td>247</td>
     <td>Core-Mark Holding</td>
     <td><a href="http://www.core-mark.com">http://www.core-mark.com</a></td>
     </tr>, <tr><td>248</td>
     <td>Bed Bath &amp; Beyond</td>
     <td><a href="http://www.bedbathandbeyond.com">http://www.bedbathandbeyond.com</a></td>
     </tr>, <tr><td>249</td>
     <td>Oneok</td>
     <td><a href="http://www.oneok.com">http://www.oneok.com</a></td>
     </tr>, <tr><td>250</td>
     <td>BB&amp;T Corp.</td>
     <td><a href="http://www.bbt.com">http://www.bbt.com</a></td>
     </tr>, <tr><td>251</td>
     <td>Becton Dickinson</td>
     <td><a href="http://www.bd.com">http://www.bd.com</a></td>
     </tr>, <tr><td>252</td>
     <td>Ameriprise Financial</td>
     <td><a href="http://www.ameriprise.com">http://www.ameriprise.com</a></td>
     </tr>, <tr><td>253</td>
     <td>Farmers Insurance Exchange</td>
     <td><a href="http://www.farmers.com">http://www.farmers.com</a></td>
     </tr>, <tr><td>254</td>
     <td>First Data</td>
     <td><a href="http://www.firstdata.com">http://www.firstdata.com</a></td>
     </tr>, <tr><td>255</td>
     <td>Consolidated Edison</td>
     <td><a href="http://www.conedison.com">http://www.conedison.com</a></td>
     </tr>, <tr><td>256</td>
     <td>Parker-Hannifin</td>
     <td><a href="http://www.parker.com">http://www.parker.com</a></td>
     </tr>, <tr><td>257</td>
     <td>Anadarko Petroleum</td>
     <td><a href="http://www.anadarko.com">http://www.anadarko.com</a></td>
     </tr>, <tr><td>258</td>
     <td>Estee Lauder</td>
     <td><a href="http://www.elcompanies.com">http://www.elcompanies.com</a></td>
     </tr>, <tr><td>259</td>
     <td>State Street Corp.</td>
     <td><a href="http://www.statestreet.com">http://www.statestreet.com</a></td>
     </tr>, <tr><td>260</td>
     <td>Tesla</td>
     <td><a href="http://www.tesla.com">http://www.tesla.com</a></td>
     </tr>, <tr><td>261</td>
     <td>Netflix</td>
     <td><a href="http://www.netflix.com">http://www.netflix.com</a></td>
     </tr>, <tr><td>262</td>
     <td>Alcoa</td>
     <td><a href="http://www.alcoa.com">http://www.alcoa.com</a></td>
     </tr>, <tr><td>263</td>
     <td>Discover Financial Services</td>
     <td><a href="http://www.discover.com">http://www.discover.com</a></td>
     </tr>, <tr><td>264</td>
     <td>Praxair</td>
     <td><a href="http://www.praxair.com">http://www.praxair.com</a></td>
     </tr>, <tr><td>265</td>
     <td>CSX</td>
     <td><a href="http://www.csx.com">http://www.csx.com</a></td>
     </tr>, <tr><td>266</td>
     <td>Xcel Energy</td>
     <td><a href="http://www.xcelenergy.com">http://www.xcelenergy.com</a></td>
     </tr>, <tr><td>267</td>
     <td>Unum Group</td>
     <td><a href="http://www.unum.com">http://www.unum.com</a></td>
     </tr>, <tr><td>268</td>
     <td>Universal Health Services</td>
     <td><a href="http://www.uhsinc.com">http://www.uhsinc.com</a></td>
     </tr>, <tr><td>269</td>
     <td>NRG Energy</td>
     <td><a href="http://www.nrg.com">http://www.nrg.com</a></td>
     </tr>, <tr><td>270</td>
     <td>EOG Resources</td>
     <td><a href="http://www.eogresources.com">http://www.eogresources.com</a></td>
     </tr>, <tr><td>271</td>
     <td>Sempra Energy</td>
     <td><a href="http://www.sempra.com">http://www.sempra.com</a></td>
     </tr>, <tr><td>272</td>
     <td>Toys “R” Us</td>
     <td><a href="http://www.toysrusinc.com">http://www.toysrusinc.com</a></td>
     </tr>, <tr><td>273</td>
     <td>Group Automotive</td>
     <td><a href="http://www.group1auto.com">http://www.group1auto.com</a></td>
     </tr>, <tr><td>274</td>
     <td>Entergy</td>
     <td><a href="http://www.entergy.com">http://www.entergy.com</a></td>
     </tr>, <tr><td>275</td>
     <td>Molson Coors Brewing</td>
     <td><a href="http://www.molsoncoors.com">http://www.molsoncoors.com</a></td>
     </tr>, <tr><td>276</td>
     <td>L Technologies</td>
     <td><a href="http://www.l3t.com">http://www.l3t.com</a></td>
     </tr>, <tr><td>277</td>
     <td>Ball</td>
     <td><a href="http://www.ball.com">http://www.ball.com</a></td>
     </tr>, <tr><td>278</td>
     <td>AutoZone</td>
     <td><a href="http://www.autozone.com">http://www.autozone.com</a></td>
     </tr>, <tr><td>279</td>
     <td>Murphy USA</td>
     <td><a href="http://www.murphyusa.com">http://www.murphyusa.com</a></td>
     </tr>, <tr><td>280</td>
     <td>MGM Resorts International</td>
     <td><a href="http://www.mgmresorts.com">http://www.mgmresorts.com</a></td>
     </tr>, <tr><td>281</td>
     <td>Office Depot</td>
     <td><a href="http://www.officedepot.com">http://www.officedepot.com</a></td>
     </tr>, <tr><td>282</td>
     <td>Huntsman</td>
     <td><a href="http://www.huntsman.com">http://www.huntsman.com</a></td>
     </tr>, <tr><td>283</td>
     <td>Baxter International</td>
     <td><a href="http://www.baxter.com">http://www.baxter.com</a></td>
     </tr>, <tr><td>284</td>
     <td>Norfolk Southern</td>
     <td><a href="http://www.norfolksouthern.com">http://www.norfolksouthern.com</a></td>
     </tr>, <tr><td>285</td>
     <td>salesforce.com</td>
     <td><a href="http://www.salesforce.com">http://www.salesforce.com</a></td>
     </tr>, <tr><td>286</td>
     <td>Laboratory Corp. of America</td>
     <td><a href="http://www.labcorp.com">http://www.labcorp.com</a></td>
     </tr>, <tr><td>287</td>
     <td>W.W. Grainger</td>
     <td><a href="http://www.grainger.com">http://www.grainger.com</a></td>
     </tr>, <tr><td>288</td>
     <td>Qurate Retail</td>
     <td><a href="http://www.libertyinteractive.com">http://www.libertyinteractive.com</a></td>
     </tr>, <tr><td>289</td>
     <td>Autoliv</td>
     <td><a href="http://www.autoliv.com">http://www.autoliv.com</a></td>
     </tr>, <tr><td>290</td>
     <td>Live Nation Entertainment</td>
     <td><a href="http://www.livenationentertainment.com">http://www.livenationentertainment.com</a></td>
     </tr>, <tr><td>291</td>
     <td>Xerox</td>
     <td><a href="http://www.xerox.com">http://www.xerox.com</a></td>
     </tr>, <tr><td>292</td>
     <td>Leidos Holdings</td>
     <td><a href="http://www.leidos.com">http://www.leidos.com</a></td>
     </tr>, <tr><td>293</td>
     <td>Corning</td>
     <td><a href="http://www.corning.com">http://www.corning.com</a></td>
     </tr>, <tr><td>294</td>
     <td>Lithia Motors</td>
     <td><a href="http://www.lithiainvestorrelations.com">http://www.lithiainvestorrelations.com</a></td>
     </tr>, <tr><td>295</td>
     <td>Expedia Group</td>
     <td><a href="http://www.expediagroup.com">http://www.expediagroup.com</a></td>
     </tr>, <tr><td>296</td>
     <td>Republic Services</td>
     <td><a href="http://www.republicservices.com">http://www.republicservices.com</a></td>
     </tr>, <tr><td>297</td>
     <td>Jacobs Engineering Group</td>
     <td><a href="http://www.jacobs.com">http://www.jacobs.com</a></td>
     </tr>, <tr><td>298</td>
     <td>Sonic Automotive</td>
     <td><a href="http://www.sonicautomotive.com">http://www.sonicautomotive.com</a></td>
     </tr>, <tr><td>299</td>
     <td>Ally Financial</td>
     <td><a href="http://www.ally.com">http://www.ally.com</a></td>
     </tr>, <tr><td>300</td>
     <td>LKQ</td>
     <td><a href="http://www.lkqcorp.com">http://www.lkqcorp.com</a></td>
     </tr>, <tr><td>301</td>
     <td>BorgWarner</td>
     <td><a href="http://www.borgwarner.com">http://www.borgwarner.com</a></td>
     </tr>, <tr><td>302</td>
     <td>Fidelity National Financial</td>
     <td><a href="http://www.fnf.com">http://www.fnf.com</a></td>
     </tr>, <tr><td>303</td>
     <td>SunTrust Banks</td>
     <td><a href="http://www.suntrust.com">http://www.suntrust.com</a></td>
     </tr>, <tr><td>304</td>
     <td>IQVIA Holdings</td>
     <td><a href="www.iqvia.com">www.iqvia.com</a></td>
     </tr>, <tr><td>305</td>
     <td>Reliance Steel &amp; Aluminum</td>
     <td><a href="http://www.rsac.com">http://www.rsac.com</a></td>
     </tr>, <tr><td>306</td>
     <td>Nvidia</td>
     <td><a href="http://www.nvidia.com">http://www.nvidia.com</a></td>
     </tr>, <tr><td>307</td>
     <td>Voya Financial</td>
     <td><a href="http://www.voya.com">http://www.voya.com</a></td>
     </tr>, <tr><td>308</td>
     <td>CenterPoint Energy</td>
     <td><a href="http://www.centerpointenergy.com">http://www.centerpointenergy.com</a></td>
     </tr>, <tr><td>309</td>
     <td>eBay</td>
     <td><a href="http://www.ebay.com">http://www.ebay.com</a></td>
     </tr>, <tr><td>310</td>
     <td>Eastman Chemical</td>
     <td><a href="http://www.eastman.com">http://www.eastman.com</a></td>
     </tr>, <tr><td>311</td>
     <td>American Family Insurance Group</td>
     <td><a href="http://www.amfam.com">http://www.amfam.com</a></td>
     </tr>, <tr><td>312</td>
     <td>Steel Dynamics</td>
     <td><a href="http://www.steeldynamics.com">http://www.steeldynamics.com</a></td>
     </tr>, <tr><td>313</td>
     <td>Pacific Life</td>
     <td><a href="http://www.pacificlife.com">http://www.pacificlife.com</a></td>
     </tr>, <tr><td>314</td>
     <td>Chesapeake Energy</td>
     <td><a href="http://www.chk.com">http://www.chk.com</a></td>
     </tr>, <tr><td>315</td>
     <td>Mohawk Industries</td>
     <td><a href="http://www.mohawkind.com">http://www.mohawkind.com</a></td>
     </tr>, <tr><td>316</td>
     <td>Quanta Services</td>
     <td><a href="http://www.quantaservices.com">http://www.quantaservices.com</a></td>
     </tr>, <tr><td>317</td>
     <td>Advance Auto Parts</td>
     <td><a href="http://www.advanceautoparts.com">http://www.advanceautoparts.com</a></td>
     </tr>, <tr><td>318</td>
     <td>Owens &amp; Minor</td>
     <td><a href="http://www.owens-minor.com">http://www.owens-minor.com</a></td>
     </tr>, <tr><td>319</td>
     <td>United Natural Foods</td>
     <td><a href="http://www.unfi.com">http://www.unfi.com</a></td>
     </tr>, <tr><td>320</td>
     <td>Tenneco</td>
     <td><a href="http://www.tenneco.com">http://www.tenneco.com</a></td>
     </tr>, <tr><td>321</td>
     <td>Conagra Brands</td>
     <td><a href="http://www.conagrabrands.com">http://www.conagrabrands.com</a></td>
     </tr>, <tr><td>322</td>
     <td>GameStop</td>
     <td><a href="http://www.gamestop.com">http://www.gamestop.com</a></td>
     </tr>, <tr><td>323</td>
     <td>Hormel Foods</td>
     <td><a href="http://www.hormelfoods.com">http://www.hormelfoods.com</a></td>
     </tr>, <tr><td>324</td>
     <td>Hilton Worldwide Holdings</td>
     <td><a href="http://www.hiltonworldwide.com">http://www.hiltonworldwide.com</a></td>
     </tr>, <tr><td>325</td>
     <td>Frontier Communications</td>
     <td><a href="http://www.frontier.com">http://www.frontier.com</a></td>
     </tr>, <tr><td>326</td>
     <td>Fidelity National Information Services</td>
     <td><a href="http://www.fisglobal.com">http://www.fisglobal.com</a></td>
     </tr>, <tr><td>327</td>
     <td>Public Service Enterprise Group</td>
     <td><a href="http://www.pseg.com">http://www.pseg.com</a></td>
     </tr>, <tr><td>328</td>
     <td>Boston Scientific</td>
     <td><a href="http://www.bostonscientific.com">http://www.bostonscientific.com</a></td>
     </tr>, <tr><td>329</td>
     <td>O’Reilly Automotive</td>
     <td><a href="http://www.oreillyauto.com">http://www.oreillyauto.com</a></td>
     </tr>, <tr><td>330</td>
     <td>Charles Schwab</td>
     <td><a href="http://www.aboutschwab.com">http://www.aboutschwab.com</a></td>
     </tr>, <tr><td>331</td>
     <td>Global Partners</td>
     <td><a href="http://www.globalp.com">http://www.globalp.com</a></td>
     </tr>, <tr><td>332</td>
     <td>PVH</td>
     <td><a href="http://www.pvh.com">http://www.pvh.com</a></td>
     </tr>, <tr><td>333</td>
     <td>Avis Budget Group</td>
     <td><a href="http://www.avisbudgetgroup.com">http://www.avisbudgetgroup.com</a></td>
     </tr>, <tr><td>334</td>
     <td>Targa Resources</td>
     <td><a href="http://www.targaresources.com">http://www.targaresources.com</a></td>
     </tr>, <tr><td>335</td>
     <td>Hertz Global Holdings</td>
     <td><a href="http://www.hertz.com">http://www.hertz.com</a></td>
     </tr>, <tr><td>336</td>
     <td>Calpine</td>
     <td><a href="http://www.calpine.com">http://www.calpine.com</a></td>
     </tr>, <tr><td>337</td>
     <td>Mutual of Omaha Insurance</td>
     <td><a href="http://www.mutualofomaha.com">http://www.mutualofomaha.com</a></td>
     </tr>, <tr><td>338</td>
     <td>Crown Holdings</td>
     <td><a href="http://www.crowncork.com">http://www.crowncork.com</a></td>
     </tr>, <tr><td>339</td>
     <td>Peter Kiewit Sons’</td>
     <td><a href="http://www.kiewit.com">http://www.kiewit.com</a></td>
     </tr>, <tr><td>340</td>
     <td>Dick’s Sporting Goods</td>
     <td><a href="http://www.dicks.com">http://www.dicks.com</a></td>
     </tr>, <tr><td>341</td>
     <td>PulteGroup</td>
     <td><a href="http://www.pultegroupinc.com">http://www.pultegroupinc.com</a></td>
     </tr>, <tr><td>342</td>
     <td>Navistar International</td>
     <td><a href="http://www.navistar.com">http://www.navistar.com</a></td>
     </tr>, <tr><td>343</td>
     <td>Thrivent Financial for Lutherans</td>
     <td><a href="http://www.thrivent.com">http://www.thrivent.com</a></td>
     </tr>, <tr><td>344</td>
     <td>DCP Midstream</td>
     <td><a href="http://www.dcpmidstream.com">http://www.dcpmidstream.com</a></td>
     </tr>, <tr><td>345</td>
     <td>Air Products &amp; Chemicals</td>
     <td><a href="http://www.airproducts.com">http://www.airproducts.com</a></td>
     </tr>, <tr><td>346</td>
     <td>Veritiv</td>
     <td><a href="http://www.veritivcorp.com">http://www.veritivcorp.com</a></td>
     </tr>, <tr><td>347</td>
     <td>AGCO</td>
     <td><a href="http://www.agcocorp.com">http://www.agcocorp.com</a></td>
     </tr>, <tr><td>348</td>
     <td>Genworth Financial</td>
     <td><a href="http://www.genworth.com">http://www.genworth.com</a></td>
     </tr>, <tr><td>349</td>
     <td>Univar</td>
     <td><a href="http://www.univar.com">http://www.univar.com</a></td>
     </tr>, <tr><td>350</td>
     <td>News Corp.</td>
     <td><a href="http://www.newscorp.com">http://www.newscorp.com</a></td>
     </tr>, <tr><td>351</td>
     <td>SpartanNash</td>
     <td><a href="http://www.spartannash.com">http://www.spartannash.com</a></td>
     </tr>, <tr><td>352</td>
     <td>Westlake Chemical</td>
     <td><a href="http://www.westlake.com">http://www.westlake.com</a></td>
     </tr>, <tr><td>353</td>
     <td>Williams</td>
     <td><a href="http://www.williams.com">http://www.williams.com</a></td>
     </tr>, <tr><td>354</td>
     <td>Lam Research</td>
     <td><a href="http://www.lamresearch.com">http://www.lamresearch.com</a></td>
     </tr>, <tr><td>355</td>
     <td>Alaska Air Group</td>
     <td><a href="http://www.alaskaair.com">http://www.alaskaair.com</a></td>
     </tr>, <tr><td>356</td>
     <td>Jones Lang LaSalle</td>
     <td><a href="http://www.jll.com">http://www.jll.com</a></td>
     </tr>, <tr><td>357</td>
     <td>Anixter International</td>
     <td><a href="http://www.anixter.com">http://www.anixter.com</a></td>
     </tr>, <tr><td>358</td>
     <td>Campbell Soup</td>
     <td><a href="http://www.campbellsoupcompany.com">http://www.campbellsoupcompany.com</a></td>
     </tr>, <tr><td>359</td>
     <td>Interpublic Group</td>
     <td><a href="http://www.interpublic.com">http://www.interpublic.com</a></td>
     </tr>, <tr><td>360</td>
     <td>Dover</td>
     <td><a href="http://www.dovercorporation.com">http://www.dovercorporation.com</a></td>
     </tr>, <tr><td>361</td>
     <td>Zimmer Biomet Holdings</td>
     <td><a href="http://www.zimmerbiomet.com">http://www.zimmerbiomet.com</a></td>
     </tr>, <tr><td>362</td>
     <td>Dean Foods</td>
     <td><a href="http://www.deanfoods.com">http://www.deanfoods.com</a></td>
     </tr>, <tr><td>363</td>
     <td>Foot Locker</td>
     <td><a href="http://www.footlocker-inc.com">http://www.footlocker-inc.com</a></td>
     </tr>, <tr><td>364</td>
     <td>Eversource Energy</td>
     <td><a href="http://www.eversource.com">http://www.eversource.com</a></td>
     </tr>, <tr><td>365</td>
     <td>Alliance Data Systems</td>
     <td><a href="http://www.alliancedata.com">http://www.alliancedata.com</a></td>
     </tr>, <tr><td>366</td>
     <td>Fifth Third Bancorp</td>
     <td><a href="http://www.53.com">http://www.53.com</a></td>
     </tr>, <tr><td>367</td>
     <td>Quest Diagnostics</td>
     <td><a href="http://www.questdiagnostics.com">http://www.questdiagnostics.com</a></td>
     </tr>, <tr><td>368</td>
     <td>EMCOR Group</td>
     <td><a href="http://www.emcorgroup.com">http://www.emcorgroup.com</a></td>
     </tr>, <tr><td>369</td>
     <td>W.R. Berkley</td>
     <td><a href="http://www.wrberkley.com">http://www.wrberkley.com</a></td>
     </tr>, <tr><td>370</td>
     <td>WESCO International</td>
     <td><a href="http://www.wesco.com">http://www.wesco.com</a></td>
     </tr>, <tr><td>371</td>
     <td>Coty</td>
     <td><a href="http://www.coty.com">http://www.coty.com</a></td>
     </tr>, <tr><td>372</td>
     <td>WEC Energy Group</td>
     <td><a href="http://www.wecenergygroup.com">http://www.wecenergygroup.com</a></td>
     </tr>, <tr><td>373</td>
     <td>Masco</td>
     <td><a href="http://www.masco.com">http://www.masco.com</a></td>
     </tr>, <tr><td>374</td>
     <td>DXC Technology</td>
     <td><a href="http://www.dxc.technology">http://www.dxc.technology</a></td>
     </tr>, <tr><td>375</td>
     <td>Auto-Owners Insurance</td>
     <td><a href="http://www.auto-owners.com">http://www.auto-owners.com</a></td>
     </tr>, <tr><td>376</td>
     <td>Jones Financial (Edward Jones)</td>
     <td><a href="www.iqvia.comwww.edwardjones.com">www.iqvia.comwww.edwardjones.com</a></td>
     </tr>, <tr><td>377</td>
     <td>Liberty Media</td>
     <td><a href="http://www.libertymedia.com">http://www.libertymedia.com</a></td>
     </tr>, <tr><td>378</td>
     <td>Erie Insurance Group</td>
     <td><a href="http://www.erieinsurance.com">http://www.erieinsurance.com</a></td>
     </tr>, <tr><td>379</td>
     <td>Hershey</td>
     <td><a href="http://www.thehersheycompany.com">http://www.thehersheycompany.com</a></td>
     </tr>, <tr><td>380</td>
     <td>PPL</td>
     <td><a href="http://www.pplweb.com">http://www.pplweb.com</a></td>
     </tr>, <tr><td>381</td>
     <td>Huntington Ingalls Industries</td>
     <td><a href="http://www.huntingtoningalls.com">http://www.huntingtoningalls.com</a></td>
     </tr>, <tr><td>382</td>
     <td>Mosaic</td>
     <td><a href="http://www.mosaicco.com">http://www.mosaicco.com</a></td>
     </tr>, <tr><td>383</td>
     <td>J.M. Smucker</td>
     <td><a href="http://www.jmsmucker.com">http://www.jmsmucker.com</a></td>
     </tr>, <tr><td>384</td>
     <td>Delek US Holdings</td>
     <td><a href="http://www.delekus.com">http://www.delekus.com</a></td>
     </tr>, <tr><td>385</td>
     <td>Newmont Mining</td>
     <td><a href="http://www.newmont.com">http://www.newmont.com</a></td>
     </tr>, <tr><td>386</td>
     <td>Constellation Brands</td>
     <td><a href="http://www.cbrands.com">http://www.cbrands.com</a></td>
     </tr>, <tr><td>387</td>
     <td>Ryder System</td>
     <td><a href="http://www.ryder.com">http://www.ryder.com</a></td>
     </tr>, <tr><td>388</td>
     <td>National Oilwell Varco</td>
     <td><a href="http://www.nov.com">http://www.nov.com</a></td>
     </tr>, <tr><td>389</td>
     <td>Adobe Systems</td>
     <td><a href="http://www.adobe.com">http://www.adobe.com</a></td>
     </tr>, <tr><td>390</td>
     <td>LifePoint Health</td>
     <td><a href="http://www.lifepointhealth.net">http://www.lifepointhealth.net</a></td>
     </tr>, <tr><td>391</td>
     <td>Tractor Supply</td>
     <td><a href="http://www.tractorsupply.com">http://www.tractorsupply.com</a></td>
     </tr>, <tr><td>392</td>
     <td>Thor Industries</td>
     <td><a href="http://www.thorindustries.com">http://www.thorindustries.com</a></td>
     </tr>, <tr><td>393</td>
     <td>Dana</td>
     <td><a href="http://www.dana.com">http://www.dana.com</a></td>
     </tr>, <tr><td>394</td>
     <td>Weyerhaeuser</td>
     <td><a href="http://www.weyerhaeuser.com">http://www.weyerhaeuser.com</a></td>
     </tr>, <tr><td>395</td>
     <td>J.B. Hunt Transport Services</td>
     <td><a href="http://www.jbhunt.com">http://www.jbhunt.com</a></td>
     </tr>, <tr><td>396</td>
     <td>Darden Restaurants</td>
     <td><a href="http://www.darden.com">http://www.darden.com</a></td>
     </tr>, <tr><td>397</td>
     <td>Yum China Holdings</td>
     <td><a href="http://ir.yumchina.com">http://ir.yumchina.com</a></td>
     </tr>, <tr><td>398</td>
     <td>Blackstone Group</td>
     <td><a href="http://www.blackstone.com">http://www.blackstone.com</a></td>
     </tr>, <tr><td>399</td>
     <td>Berry Global Group</td>
     <td><a href="http://www.berryglobal.com">http://www.berryglobal.com</a></td>
     </tr>, <tr><td>400</td>
     <td>Builders FirstSource</td>
     <td><a href="http://www.bldr.com">http://www.bldr.com</a></td>
     </tr>, <tr><td>401</td>
     <td>Activision Blizzard</td>
     <td><a href="http://www.activisionblizzard.com">http://www.activisionblizzard.com</a></td>
     </tr>, <tr><td>402</td>
     <td>JetBlue Airways</td>
     <td><a href="http://www.jetblue.com">http://www.jetblue.com</a></td>
     </tr>, <tr><td>403</td>
     <td>Amphenol</td>
     <td><a href="http://www.amphenol.com">http://www.amphenol.com</a></td>
     </tr>, <tr><td>404</td>
     <td>A-Mark Precious Metals</td>
     <td><a href="http://www.amark.com">http://www.amark.com</a></td>
     </tr>, <tr><td>405</td>
     <td>Spirit AeroSystems Holdings</td>
     <td><a href="http://www.spiritaero.com">http://www.spiritaero.com</a></td>
     </tr>, <tr><td>406</td>
     <td>R.R. Donnelley &amp; Sons</td>
     <td><a href="http://www.rrdonnelley.com">http://www.rrdonnelley.com</a></td>
     </tr>, <tr><td>407</td>
     <td>Harris</td>
     <td><a href="http://www.harris.com">http://www.harris.com</a></td>
     </tr>, <tr><td>408</td>
     <td>Expeditors Intl. of Washington</td>
     <td><a href="http://www.expeditors.com">http://www.expeditors.com</a></td>
     </tr>, <tr><td>409</td>
     <td>Discovery</td>
     <td><a href="http://www.discovery.com">http://www.discovery.com</a></td>
     </tr>, <tr><td>410</td>
     <td>Owens-Illinois</td>
     <td><a href="http://www.o-i.com">http://www.o-i.com</a></td>
     </tr>, <tr><td>411</td>
     <td>Sanmina</td>
     <td><a href="http://www.sanmina.com">http://www.sanmina.com</a></td>
     </tr>, <tr><td>412</td>
     <td>KeyCorp</td>
     <td><a href="http://www.key.com">http://www.key.com</a></td>
     </tr>, <tr><td>413</td>
     <td>American Financial Group</td>
     <td><a href="http://www.afginc.com">http://www.afginc.com</a></td>
     </tr>, <tr><td>414</td>
     <td>Oshkosh</td>
     <td><a href="http://www.oshkoshcorporation.com">http://www.oshkoshcorporation.com</a></td>
     </tr>, <tr><td>415</td>
     <td>Rockwell Collins</td>
     <td><a href="http://www.rockwellcollins.com">http://www.rockwellcollins.com</a></td>
     </tr>, <tr><td>416</td>
     <td>Kindred Healthcare</td>
     <td><a href="http://www.kindredhealthcare.com">http://www.kindredhealthcare.com</a></td>
     </tr>, <tr><td>417</td>
     <td>Insight Enterprises</td>
     <td><a href="http://www.insight.com">http://www.insight.com</a></td>
     </tr>, <tr><td>418</td>
     <td>Dr Pepper Snapple Group</td>
     <td><a href="http://www.drpeppersnapplegroup.com">http://www.drpeppersnapplegroup.com</a></td>
     </tr>, <tr><td>419</td>
     <td>American Tower</td>
     <td><a href="http://www.americantower.com">http://www.americantower.com</a></td>
     </tr>, <tr><td>420</td>
     <td>Fortive</td>
     <td><a href="http://www.fortive.com">http://www.fortive.com</a></td>
     </tr>, <tr><td>421</td>
     <td>Ralph Lauren</td>
     <td><a href="http://www.ralphlauren.com">http://www.ralphlauren.com</a></td>
     </tr>, <tr><td>422</td>
     <td>HRG Group</td>
     <td><a href="http://www.hrggroup.com">http://www.hrggroup.com</a></td>
     </tr>, <tr><td>423</td>
     <td>Ascena Retail Group</td>
     <td><a href="http://www.ascenaretail.com">http://www.ascenaretail.com</a></td>
     </tr>, <tr><td>424</td>
     <td>United Rentals</td>
     <td><a href="http://www.unitedrentals.com">http://www.unitedrentals.com</a></td>
     </tr>, <tr><td>425</td>
     <td>Casey’s General Stores</td>
     <td><a href="http://www.caseys.com">http://www.caseys.com</a></td>
     </tr>, <tr><td>426</td>
     <td>Graybar Electric</td>
     <td><a href="http://www.graybar.com">http://www.graybar.com</a></td>
     </tr>, <tr><td>427</td>
     <td>Avery Dennison</td>
     <td><a href="http://www.averydennison.com">http://www.averydennison.com</a></td>
     </tr>, <tr><td>428</td>
     <td>MasTec</td>
     <td><a href="http://www.mastec.com">http://www.mastec.com</a></td>
     </tr>, <tr><td>429</td>
     <td>CMS Energy</td>
     <td><a href="http://www.cmsenergy.com">http://www.cmsenergy.com</a></td>
     </tr>, <tr><td>430</td>
     <td>HD Supply Holdings</td>
     <td><a href="http://www.hdsupply.com">http://www.hdsupply.com</a></td>
     </tr>, <tr><td>431</td>
     <td>Raymond James Financial</td>
     <td><a href="http://www.raymondjames.com">http://www.raymondjames.com</a></td>
     </tr>, <tr><td>432</td>
     <td>NCR</td>
     <td><a href="http://www.ncr.com">http://www.ncr.com</a></td>
     </tr>, <tr><td>433</td>
     <td>Hanesbrands</td>
     <td><a href="http://www.hanes.com">http://www.hanes.com</a></td>
     </tr>, <tr><td>434</td>
     <td>Asbury Automotive Group</td>
     <td><a href="http://www.asburyauto.com">http://www.asburyauto.com</a></td>
     </tr>, <tr><td>435</td>
     <td>Citizens Financial Group</td>
     <td><a href="http://www.citizensbank.com">http://www.citizensbank.com</a></td>
     </tr>, <tr><td>436</td>
     <td>Packaging Corp. of America</td>
     <td><a href="http://www.packagingcorp.com">http://www.packagingcorp.com</a></td>
     </tr>, <tr><td>437</td>
     <td>Alleghany</td>
     <td><a href="http://www.alleghany.com">http://www.alleghany.com</a></td>
     </tr>, <tr><td>438</td>
     <td>Apache</td>
     <td><a href="http://www.apachecorp.com">http://www.apachecorp.com</a></td>
     </tr>, <tr><td>439</td>
     <td>Dillard’s</td>
     <td><a href="http://www.dillards.com">http://www.dillards.com</a></td>
     </tr>, <tr><td>440</td>
     <td>Assurant</td>
     <td><a href="http://www.assurant.com">http://www.assurant.com</a></td>
     </tr>, <tr><td>441</td>
     <td>Franklin Resources</td>
     <td><a href="http://www.franklinresources.com">http://www.franklinresources.com</a></td>
     </tr>, <tr><td>442</td>
     <td>Owens Corning</td>
     <td><a href="http://www.owenscorning.com">http://www.owenscorning.com</a></td>
     </tr>, <tr><td>443</td>
     <td>Motorola Solutions</td>
     <td><a href="http://www.motorolasolutions.com">http://www.motorolasolutions.com</a></td>
     </tr>, <tr><td>444</td>
     <td>NVR</td>
     <td><a href="http://www.nvrinc.com">http://www.nvrinc.com</a></td>
     </tr>, <tr><td>445</td>
     <td>Rockwell Automation</td>
     <td><a href="http://www.rockwellautomation.com">http://www.rockwellautomation.com</a></td>
     </tr>, <tr><td>446</td>
     <td>TreeHouse Foods</td>
     <td><a href="http://www.treehousefoods.com">http://www.treehousefoods.com</a></td>
     </tr>, <tr><td>447</td>
     <td>Wynn Resorts</td>
     <td><a href="http://www.wynnresorts.com">http://www.wynnresorts.com</a></td>
     </tr>, <tr><td>448</td>
     <td>Olin</td>
     <td><a href="http://www.olin.com">http://www.olin.com</a></td>
     </tr>, <tr><td>449</td>
     <td>American Axle &amp; Manufacturing</td>
     <td><a href="http://www.aam.com">http://www.aam.com</a></td>
     </tr>, <tr><td>450</td>
     <td>Old Republic International</td>
     <td><a href="http://www.oldrepublic.com">http://www.oldrepublic.com</a></td>
     </tr>, <tr><td>451</td>
     <td>Chemours</td>
     <td><a href="http://www.chemours.com">http://www.chemours.com</a></td>
     </tr>, <tr><td>452</td>
     <td>iHeartMedia</td>
     <td><a href="http://www.iheartmedia.com">http://www.iheartmedia.com</a></td>
     </tr>, <tr><td>453</td>
     <td>Ameren</td>
     <td><a href="http://www.ameren.com">http://www.ameren.com</a></td>
     </tr>, <tr><td>454</td>
     <td>Arthur J. Gallagher</td>
     <td><a href="http://www.ajg.com">http://www.ajg.com</a></td>
     </tr>, <tr><td>455</td>
     <td>Celanese</td>
     <td><a href="http://www.celanese.com">http://www.celanese.com</a></td>
     </tr>, <tr><td>456</td>
     <td>Sealed Air</td>
     <td><a href="http://www.sealedair.com">http://www.sealedair.com</a></td>
     </tr>, <tr><td>457</td>
     <td>UGI</td>
     <td><a href="http://www.ugicorp.com">http://www.ugicorp.com</a></td>
     </tr>, <tr><td>458</td>
     <td>Realogy Holdings</td>
     <td><a href="http://www.realogy.com">http://www.realogy.com</a></td>
     </tr>, <tr><td>459</td>
     <td>Burlington Stores</td>
     <td><a href="http://www.burlington.com">http://www.burlington.com</a></td>
     </tr>, <tr><td>460</td>
     <td>Regions Financial</td>
     <td><a href="http://www.regions.com">http://www.regions.com</a></td>
     </tr>, <tr><td>461</td>
     <td>AK Steel Holding</td>
     <td><a href="http://www.aksteel.com">http://www.aksteel.com</a></td>
     </tr>, <tr><td>462</td>
     <td>Securian Financial Group</td>
     <td><a href="http://www.securian.com">http://www.securian.com</a></td>
     </tr>, <tr><td>463</td>
     <td>S&amp;P Global</td>
     <td><a href="http://www.spglobal.com">http://www.spglobal.com</a></td>
     </tr>, <tr><td>464</td>
     <td>Markel</td>
     <td><a href="http://www.markelcorp.com">http://www.markelcorp.com</a></td>
     </tr>, <tr><td>465</td>
     <td>TravelCenters of America</td>
     <td><a href="http://www.ta-petro.com">http://www.ta-petro.com</a></td>
     </tr>, <tr><td>466</td>
     <td>Conduent</td>
     <td><a href="http://www.conduent.com">http://www.conduent.com</a></td>
     </tr>, <tr><td>467</td>
     <td>M&amp;T Bank Corp.</td>
     <td><a href="http://www.mtb.com">http://www.mtb.com</a></td>
     </tr>, <tr><td>468</td>
     <td>Clorox</td>
     <td><a href="http://www.thecloroxcompany.com">http://www.thecloroxcompany.com</a></td>
     </tr>, <tr><td>469</td>
     <td>AmTrust Financial Services</td>
     <td><a href="http://www.amtrustfinancial.com">http://www.amtrustfinancial.com</a></td>
     </tr>, <tr><td>470</td>
     <td>KKR</td>
     <td><a href="http://www.kkr.com">http://www.kkr.com</a></td>
     </tr>, <tr><td>471</td>
     <td>Ulta Beauty</td>
     <td><a href="http://www.ulta.com">http://www.ulta.com</a></td>
     </tr>, <tr><td>472</td>
     <td>Yum Brands</td>
     <td><a href="http://www.yum.com">http://www.yum.com</a></td>
     </tr>, <tr><td>473</td>
     <td>Regeneron Pharmaceuticals</td>
     <td><a href="http://www.regeneron.com">http://www.regeneron.com</a></td>
     </tr>, <tr><td>474</td>
     <td>Windstream Holdings</td>
     <td><a href="http://www.windstream.com">http://www.windstream.com</a></td>
     </tr>, <tr><td>475</td>
     <td>Magellan Health</td>
     <td><a href="http://www.magellanhealth.com">http://www.magellanhealth.com</a></td>
     </tr>, <tr><td>476</td>
     <td>Western &amp; Southern Financial</td>
     <td><a href="http://www.westernsouthern.com">http://www.westernsouthern.com</a></td>
     </tr>, <tr><td>477</td>
     <td>Intercontinental Exchange</td>
     <td><a href="http://www.theice.com">http://www.theice.com</a></td>
     </tr>, <tr><td>478</td>
     <td>Ingredion</td>
     <td><a href="http://www.ingredion.com">http://www.ingredion.com</a></td>
     </tr>, <tr><td>479</td>
     <td>Wyndham Destinations</td>
     <td><a href="http://www.wyndhamdestinations.com">http://www.wyndhamdestinations.com</a></td>
     </tr>, <tr><td>480</td>
     <td>Toll Brothers</td>
     <td><a href="http://www.tollbrothers.com">http://www.tollbrothers.com</a></td>
     </tr>, <tr><td>481</td>
     <td>Seaboard</td>
     <td><a href="http://www.seaboardcorp.com">http://www.seaboardcorp.com</a></td>
     </tr>, <tr><td>482</td>
     <td>Booz Allen Hamilton</td>
     <td><a href="http://www.boozallen.com">http://www.boozallen.com</a></td>
     </tr>, <tr><td>483</td>
     <td>First American Financial</td>
     <td><a href="http://www.firstam.com">http://www.firstam.com</a></td>
     </tr>, <tr><td>484</td>
     <td>Cincinnati Financial</td>
     <td><a href="http://www.cinfin.com">http://www.cinfin.com</a></td>
     </tr>, <tr><td>485</td>
     <td>Avon Products</td>
     <td><a href="http://www.avoninvestor.com">http://www.avoninvestor.com</a></td>
     </tr>, <tr><td>486</td>
     <td>Northern Trust</td>
     <td><a href="http://www.northerntrust.com">http://www.northerntrust.com</a></td>
     </tr>, <tr><td>487</td>
     <td>Fiserv</td>
     <td><a href="http://www.fiserv.com">http://www.fiserv.com</a></td>
     </tr>, <tr><td>488</td>
     <td>Harley-Davidson</td>
     <td><a href="http://www.harley-davidson.com">http://www.harley-davidson.com</a></td>
     </tr>, <tr><td>489</td>
     <td>Cheniere Energy</td>
     <td><a href="http://www.cheniere.com">http://www.cheniere.com</a></td>
     </tr>, <tr><td>490</td>
     <td>Patterson</td>
     <td><a href="http://www.pattersoncompanies.com">http://www.pattersoncompanies.com</a></td>
     </tr>, <tr><td>491</td>
     <td>Peabody Energy</td>
     <td><a href="http://www.peabodyenergy.com">http://www.peabodyenergy.com</a></td>
     </tr>, <tr><td>492</td>
     <td>ON Semiconductor</td>
     <td><a href="http://www.onsemi.com">http://www.onsemi.com</a></td>
     </tr>, <tr><td>493</td>
     <td>Simon Property Group</td>
     <td><a href="http://www.simon.com">http://www.simon.com</a></td>
     </tr>, <tr><td>494</td>
     <td>Western Union</td>
     <td><a href="http://www.westernunion.com">http://www.westernunion.com</a></td>
     </tr>, <tr><td>495</td>
     <td>NetApp</td>
     <td><a href="http://www.netapp.com">http://www.netapp.com</a></td>
     </tr>, <tr><td>496</td>
     <td>Polaris Industries</td>
     <td><a href="http://www.polaris.com">http://www.polaris.com</a></td>
     </tr>, <tr><td>497</td>
     <td>Pioneer Natural Resources</td>
     <td><a href="http://www.pxd.com">http://www.pxd.com</a></td>
     </tr>, <tr><td>498</td>
     <td>ABM Industries</td>
     <td><a href="http://www.abm.com">http://www.abm.com</a></td>
     </tr>, <tr><td>499</td>
     <td>Vistra Energy</td>
     <td><a href="http://www.vistraenergy.com">http://www.vistraenergy.com</a></td>
     </tr>, <tr><td>500</td>
     <td>Cintas</td>
     <td><a href="http://www.cintas.com">http://www.cintas.com</a></td>
     </tr>]




```python
fortune_500_df = pd.DataFrame(columns = ['rank', 'company_name', 'company_website'])
ix = 0

for row in all_values[1:]:
    values = row.find_all('td')
    rank = values[0].text
    company = values[1].text
    website = values[2].text
    
    fortune_500_df.loc[ix] = [rank, company, website]
    ix += 1
    
fortune_500_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>rank</th>
      <th>company_name</th>
      <th>company_website</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>1</td>
      <td>Walmart</td>
      <td>http://www.stock.walmart.com</td>
    </tr>
    <tr>
      <td>1</td>
      <td>2</td>
      <td>Exxon Mobil</td>
      <td>http://www.exxonmobil.com</td>
    </tr>
    <tr>
      <td>2</td>
      <td>3</td>
      <td>Berkshire Hathaway</td>
      <td>http://www.berkshirehathaway.com</td>
    </tr>
    <tr>
      <td>3</td>
      <td>4</td>
      <td>Apple</td>
      <td>http://www.apple.com</td>
    </tr>
    <tr>
      <td>4</td>
      <td>5</td>
      <td>UnitedHealth Group</td>
      <td>http://www.unitedhealthgroup.com</td>
    </tr>
  </tbody>
</table>
</div>



## 4. Store it in the appropriate format - CSV, TSV and export the results


```python
fortune_500_df.to_csv('./fortune_500_companies.csv', index=False)
```


```python

```
