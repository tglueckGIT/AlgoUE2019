use strict;
use warnings;
use diagnostics;
use Getopt::Long;

use feature 'say';

use feature 'switch';

# comment
my $eingabe = 0;
my $all = '';
my $help = '';
GetOptions
(
    "number=n" => \$eingabe,
    "all"  => \$all,
    "help" => \$help
)
or die("Ein ungueltiger Parameter wurde eingegeben.");

my $vorh_wert = 0;
my $akt_wert = 1;
if ($all)
{
    print "Fibonaccisequenz bis Stelle $eingabe:\n";
    print "1";
    for (my $i=1; $i<$eingabe; $i++)
    {
        $akt_wert = $akt_wert + $vorh_wert;
        print ", $akt_wert";
        $vorh_wert = $akt_wert;
    }
}
else
{
    print "$eingabe. Zahl in der Fibonaccisequenz:\n";
    for (my $i=1; $i<$eingabe; $i++)
    {
        $akt_wert = $akt_wert + $vorh_wert;
        $vorh_wert = $akt_wert;
    }
    print $akt_wert; 
}
print "\n";
if ($help)
{
    print
    ("\n\nDieses Programm gibt Ihnen wahlweise eine bestimmte Zahl aus der Fibonacci-\nsequenz aus, oder alle Zahlen der Fibonaccisequenz.\n\nOptionen:\n\n-n, -number \tZahl bis zu der die Fibonaccisequenz berechnet\n\t\twerden soll.\n--all   \tGibt alle Schritte der Fibonaccisequnez bis n aus.\n--help  \tZeigt diese Hilfe an.\n\n");
}