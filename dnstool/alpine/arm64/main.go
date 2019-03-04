package main
 
import (
	"flag"
	"fmt"
	"net"
	"os"
	"text/template"	
)

type DnsLookup struct {
	Host string
	Ips []net.IP
}

func main() {	

	hostPtr := flag.String("host", "localhost", "Hostname to resolve")
	lenPtr := flag.Bool("len", false, "Count DNS responses")
	fmtPtr := flag.String("fmt", "", "Format DNS responses")
	debugPtr := flag.Bool("debug", false, "Print debug output")
	flag.Parse()

	if *debugPtr {
		fmt.Println("host:", *hostPtr)
    	fmt.Println("len:", *lenPtr)
		fmt.Println("fmt:", *fmtPtr)
	}

	if len(*hostPtr) > 0 {
		lookup := DnsLookup{Host: *hostPtr}
		ips, _ := net.LookupIP(lookup.Host)
		lookup.Ips = ips		

		if *lenPtr {
			fmt.Print(len(lookup.Ips))
		} else if len(*fmtPtr) > 0 {
			tmpl, _ := template.New("").Parse(*fmtPtr)
			_ = tmpl.Execute(os.Stdout, lookup)
		}
	}

	//dnstool -host="minio" -len
	//dnstool -host="minio" -fmt="format string"
}