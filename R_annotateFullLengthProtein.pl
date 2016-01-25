#!/usr/bin/perl -w
use strict;

#written by erin crowgey
#this script annotates a MS data file with the position on the full length protein where the modifications are located

my $input = "heart_input123.txt"; #library file
open(IN, $input) or die "cannot open the input file\n";

my $fasta = "UP_Human_Canonical_July14_iRT.fasta"; #or UP_Human_
open(IN1, $fasta) or die "Cannot open the fasta file\n";
################################################################################

my $output = "Human_heart_annotatedPosition.txt";
open(OUT, ">$output") or die "Cannot open the output file\n";

################################################################################
my ($sequence, $ac, $protein, $gene);
$sequence = '';
my %info;
my $count = 0;

while(<IN1>){
    chomp $_;
    my $line = $_;
    
    if ($line =~ m/^\>/){
            my @array = split(/\|/, $line);
            
            if ($count == 0){
                $ac = $array[1];
                $count ++;
            }
            
            else{
                $info{$ac}{'sequence'} = $sequence;
                $sequence = '';
                $ac = $array[1];
                
            }
            
            
        
    }
    
    else {
        $sequence = $sequence . $line;
        
    }
        
    
    
}

$info{$ac}{'sequence'} = $sequence;


################################################################################
#file that needs annotation

while(<IN>){
    chomp $_;
    my $line = $_;
    my @mod;
    my $position;
    
    my @array = split(/\t/, $line);
    my $accession = $array[2];
    my $unmod = $array[0];
    my $mod = $array[1];
    
    my $results = index($info{$accession}{'sequence'}, $unmod);
    
    $mod =~ s/R\[Dea\]/R\|/g;
    $mod =~ s/\[\w+\]//g;
    $mod =~ s/\-//;
   
    my @positions = split(/\|/, $mod);
    my $size = scalar(@positions);
    my $number = 0;
    my $before = 0;
    my $string = '';
    $size = $size -1;
    
    foreach (my $c = 0; $c < $size; $c++){
        my $length = length($positions[$c]);
        
        $before = $before + $length;
        $number = $results + $before;
        $string .= $number . "\, ";
        
        
    }
    
    
    print OUT "$string\t$line\n";
    
    
}   
    

#################################################################################
