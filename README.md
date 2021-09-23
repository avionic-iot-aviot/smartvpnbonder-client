### Note

Per far sì che mlvpn funzioni, occorre prima inizializzare le tabelle di routing sim1 e sim2, mediante lo script "scripts/set_rtables.sh". Tale script va lanciato una volta sola, in fase di configurazione.

Occorre modificare i permessi di "scripts/vpn0-bonding.sh" (chmod 700), altrimenti mlvpn non eseguirà lo script (segnala un warning).

Preferibilmente installare lo smartvpn bonder client in "/home/pi/smart-vpn-bonder-client", in modo da non dover modificare i riferimenti nei file di configurazione e negli script.


# Configurazione servizi `systemd`

Nella cartella `systemd-scripts` sono presenti i servizi `systemd` che dovranno essere eseguiti al boot. In particolare:
 - `simX-connection.service`: configurazione `wvdial` per l'attivazione della connessione dati sulla `simX`;
 - `smart-vpn-bonder.service`: avvia e controlla la corretta esecuzione del servizio `MLVPN`;
 - `kpi-monitoring.service`: avvia lo script che periodicamente analizza le KPI delle connessioni SIM;

Per attivarli, basta copiarli all'interno della cartella /etc/systemd/system (vanno infatti eseguiti come root).

Nei paragrafi successivi viene dettagliata la configurazione e il funzionamento di ciascun servizio, evidenziando le dipendenze con altri moduli software.

 ## configurazione udev per renaming device USB [dongle 3G/4G]


Si e' reso necessario modificare il comportamento del demone udev all'inserimento di 
un nuovo dongle 3G/4G per rendere indipendente la configurazione di 'wvial' (quindi PPP)
dalla porta USB utilizzata per collegare il dongle 3G/4G.


### Installazione

1. Copiare il file `cfg/udev/99-huawei-link.rules' in /lib/udev/rules.d/`
2. Modificare la variabile 'PROGRAM' presente in `99-huawei-link.rules` in modo tale
   da puntare correttamente all'eseguibile `scripts/device_namer` presente nella directory del progetto smart-vpn-bonder (default: scripts/device_namer). NOTA: il file di configurazione fornito e' valido solo per Raspberry 4.
3. Effettare il reload della configurazione 'udev':
   `$ sudo udevadm control --reload-rules`
4. Provare a collegare il dongle 3G/4G, dovrebbe compare il device virtuale `/dev/ttyusbX` in funzione della porta in cui e' stato collegato


### Mappatura porte USB -> device ttyusbX -> pppY

Il Raspberry 4 e' corredato di 4 porte USB. Le porte valide per il dongle 3G/4G sono SOLO
le USB3.0. Le porte USB sono cosi' mappate:
 - PORTA USB3.0 superiore destra (accanto eth) -> ttyusb0 -> ppp0 -> `SIM1`
 - PORTA USB3.0 inferiore destra (accanto eth) -> ttyusb2 -> ppp1 -> `SIM2`

Il valori generati devono corrispondere con quelli impostati nei file di configurazione di 'wvdial' (vedi paragrafo 'servizi `simX-connection.service`')
 

 ## servizi `simX-connection.service`

 Per utilizzare tale servizio, è necessario installare `wvdial`:
 
 `$ sudo apt-get install wvdial`

 Successivamente, copiare i file `.conf` presenti in `cfg/wvdial` in `/etc` ed editare il campo `Init1` nella parte associata al nome dell'APN, inserendo il valore giusto in funzione dell'operatore della SIM. Inoltre, copiare `systemd/simX-connection.service` in `/lib/systemd/system/` e assicurarsi che i path presenti nel service siano coerenti con i percorsi dello specifico sistema ed infine abilitare il servizio:

 `$ sudo systemctl enable simX-connection.service`

 Effettuare il `reboot` del RPI e verificare che la connessione SIM venga attivata.

 ## servizio `smart-vpn-bonder.service`

 Il servizio in oggetto, ha il compito di eseguire avviare il bonding sfruttando il tool  [`MLVPN`](https://github.com/zehome/MLVPN/releases/download/2.3.5/mlvpn-2.3.5.tar.gz). In particolare, viene avviato lo script bash `bonding-monitoring.sh` che avvia e controlla la corretta esecuzione di `MLVPN` con un intervallo di tempo specificato come parametro.

 Copiare `systemd/smart-vpn-bonder.service` in `/lib/systemd/system/` e assicurarsi che i path presenti nel service siano coerenti con i percorsi dello specifico sistema ed infine abilitare il servizio:

 `$ sudo systemctl enable smart-vpn-bonder.service`

 Effettuare il `reboot` del RPI e verificare che la connessione SIM venga attivata.

 Nota: il servizio viene avviato dopo che `simX-connection.service` è attivo.

 ## servizio `kpi-monitoring.service`
 
 Servizio utile al monitoraggio delle Key Perfomance Indicator e nello specifico:
  - throughtput
  - latency
  - jitter

Il servizio avvia e controlla lo script `scripts/kpi-estimations.sh`.

Copiare `systemd/kpi-monitor.service` in `/lib/systemd/system/` e assicurarsi che i path presenti nel service siano coerenti con i percorsi dello specifico sistema ed infine abilitare il servizio:

 `$ sudo systemctl enable kpi-monitor.service`

 Effettuare il `reboot` del RPI e verificare che la connessione SIM venga attivata.

 Nota: il servizio viene avviato dopo che `smart-vpn-bonder.service` è attivo.

### Modificare le interfacce di rete

Di default, lo smartvpn bonder client utilizza le interfacce di rete ppp0 e ppp1 (che sarebbero le 2 SIM del dongle).

Se si vuole utilizzare delle interacce di rete differenti, è necessario fare alcune modifiche:

1. Editare "./bonding-monitoring.sh". Nelle righe 7 e 8, sostituire ppp0 e ppp1 con le interfacce desiderate.
2. Editare "systemd-scripts/kpi-monitor.service". Nella riga 8, sostituire ppp0 e ppp1 con le interfacce desiderate. Nota: è necessario copiare nuovamente il file in "/etc/systemd/system/".
3. Editare "scripts/source_routing.sh". Effettuare le sostituzioni. Cambiare i default route con quelli corretti (è possibile ottenerli mediante il comando "ip route").