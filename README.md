# Detainer-Warrant-PDF-Parser
A script that parses out PDF files containing detainer warrant data. 

The problem to be solved invovles an organization needing to be able to drop PDF files into a folder that may overlap in time windows and generate a CSV file containing a unique id (for deduplication), the data of the detainer warrant, and the zip code of the defendant's address. The data would be then used in a Business Intelligence dashboard for a city to monitor the amount of detainer warrants per zip code over time. 

The following image shows how the data is structured and what it looks like after being read into R using `pdf_text()`:
![detainer warrants](https://github.com/ThomasPepperz/Detainer-Warrant-PDF-Parser/blob/main/images/ex1.png?raw=true)

The unique identifier needs to be exstracted prior to parsing. Each ID ends with "DT" so the idea is to match a string ending in "DT" and then to pull the five numbers immediately preceding the matched string. Because the detainer warrants increments by 1 with each new warrant being served, to prepare for impending expansion of IDs to six digits, the regex used is `".{6}DT"`. 

[detainer warrants](https://github.com/ThomasPepperz/Detainer-Warrant-PDF-Parser/tree/main/images/ex2.png?raw=true)


However, because there is a new paragraph character currently at the sixth index prior to `DT`, the ID returned will need to have the `\n` removed from the string also. 

[detainer warrants](https://github.com/ThomasPepperz/Detainer-Warrant-PDF-Parser/tree/main/images/ex3.png?raw=true)


The PDFs contain both a plantiff and a defendant's address; however, the defendant's zip code is to be used, so the string "DEFENDANT ADDR:" can be used to reliably split the data into similarly-structured components.

[detainer warrants](https://github.com/ThomasPepperz/Detainer-Warrant-PDF-Parser/tree/main/images/ex4.png?raw=true)


The zip code needs to be extracted from each element of the list object created. Because some addresses contain five digits and because all zip codes are preceded with "TN " prior to the zip in "DEFENDANT ADDR:", the following regex was used to extract zip codes: `"TN \\d{5}"`.

[detainer warrants](https://github.com/ThomasPepperz/Detainer-Warrant-PDF-Parser/tree/main/images/ex5.png?raw=true)

In order to extract the date from each detainer warrant, the following regex was used to pull the last required piece: `"\\d+/\\d+/\\d+"`

[detainer warrants](https://github.com/ThomasPepperz/Detainer-Warrant-PDF-Parser/tree/main/images/ex6.png?raw=true)

