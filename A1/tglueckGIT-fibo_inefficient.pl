use strict;
use warnings;
use diagnostics;
use Getopt::Long;

use feature 'say';

use feature 'switch';

# comment
sub fibonacci
{
    my $n = shift;
    if ($n <= 1)
    {
        return $n;
    }
    else
    {
        return fibonacci($n-1)+fibonacci($n-2);
    }
}

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

print fibonacci($eingabe);

print "\n";
if ($help)
{
    print
    ("\n\nDieses Programm gibt Ihnen wahlweise eine bestimmte Zahl aus der Fibonacci-\nsequenz aus, oder alle Zahlen der Fibonaccisequenz.\n\nOptionen:\n\n-n, -number \tZahl bis zu der die Fibonaccisequenz berechnet\n\t\twerden soll.\n--all   \tGibt alle Schritte der Fibonaccisequnez bis n aus.\n--help  \tZeigt diese Hilfe an.\n\n");
}