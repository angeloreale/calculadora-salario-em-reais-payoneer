#!/bin/bash
USD_TOTAL_FLAT_RATE_INCOME=0 # adicione seu flat rate em dolar aqui
EUR_TOTAL_FLAT_RATE_INCOME=0 #adicione seu flat rate em euro aqui
TOEMAIL="your@email.com" #adicione seu email aqui


rm ./today-rate
touch ./today-rate
curl 'https://api.exchangeratesapi.io/latest?base=USD&symbols=BRL' | jq -r .rates.BRL > ./today-rate
curl 'https://api.exchangeratesapi.io/latest?base=EUR&symbols=BRL' | jq -r .rates.BRL >> ./today-rate
USD_RATE=`awk 'NR==1' ./today-rate`
EUR_RATE=`awk 'NR==2' ./today-rate`
P_SPREAD=0.9702
PAYONEER_DOLLAR=$(expr $USD_RATE*$P_SPREAD | bc)
PAYONEER_EURO=$(expr $EUR_RATE*$P_SPREAD | bc)
USD_TOTAL=$(expr $PAYONEER_DOLLAR*$USD_TOTAL_FLAT_RATE_INCOME | bc)
EUR_TOTAL=$(expr $PAYONEER_EURO*$EUR_TOTAL_FLAT_RATE_INCOME | bc)
T=$(expr $USD_TOTAL+$EUR_TOTAL | bc)

# Subject
SUBJECT="Yo dude, watch your money!"

# Message
MESSAGE="Dolar today is R\$${USD_RATE} and Euro is R\$${EUR_RATE}. Payoneer will pay you R\$${PAYONEER_DOLLAR} per Dolar and R\$${PAYONEER_EURO} per Euro. If you work all normal hours, this should be USD: R\$${USD_TOTAL}. EUR: R\$${EUR_TOTAL}. Which, in total, should be around R\$${T}."
EMAILMESSAGE="./message.txt"
echo $MESSAGE >$EMAILMESSAGE
# Sending email using /bin/mail
/usr/bin/mail -s "$SUBJECT" "$TOEMAIL" < $EMAILMESSAGE

