
#DEFINE GLOBAL
def define_globals
	$prog_c=-1
	$pass_c=0
	$byte_c=[0,0]
	$cycle_c=[0,0]
	$assem=[0],[0,0] 
	$start_l_h=[0,0],[0,0]
	$prg_title=[0,0]
	$l_hash={"ryan liston"=>2021}
	#hex_table
	$hexdec={"0"=>0,"1"=>1,"2"=>2,"3"=>3,"4"=>4,"5"=>5,"6"=>6,"7"=>7,"8"=>8,"9"=>9,"a"=>10,"b"=>11,"c"=>12,"d"=>13,"e"=>14,"f"=>15}
	$e_call=["error! ","error! illegal quantity!","error! inappropriate addressing mode!"]
	end
define_globals

#print info line
#def pr_info op,x4,x5
#	$assem [$prog_c][$byte_c[$prog_c]]=x5
#	puts "#{x5}\t byte: #{$byte_c[$prog_c]}\t cycles: #{$opt_tab[op][2][x4]}\t total cycles: #{$cycle_c[$prog_c]}\t address: #{$s_start+$byte_c[$prog_c]}"    
#	$byte_c[$prog_c]+=1
#	end

#hex input
def hex h_string
	h_len=h_string.length
	dec_v=0
	while h_len>0
		h_len-=1
		dec_v+=$hexdec[h_string[h_len]]*16**(h_string.length-1-h_len)
		end
	return dec_v
	end	

#bin input
def bin b_string
	b_len=b_string.length
	dec_v=0
	while b_len>0
		b_len-=1
		dec_v+=b_string[b_len].to_i*2**(b_string.length-1-b_len)
		end
	return dec_v
	end	

#error report
def er_rpt e1
	puts "#{$e_call[0]} #{$e_call[e1]}"
		er=gets
	end
	
#DECLARE NEW PROGRAM
def new_prg title,s_start
	puts "...................................................................................................."
	$prog_c+=1
	$s_start=s_start
	$l_hash[title]=$s_start    #???????????????????????????????????????????????????
	$start_l_h[$prog_c][1]=$s_start/256
	$start_l_h[$prog_c][0]=$s_start-$start_l_h[$prog_c][1]*256
	
	$prg_title[$prog_c]=title
	puts $prg_title[$prog_c]
	puts "start adress=#{$s_start}"
	puts $start_l_h[$prog_c][0] 
	puts $start_l_h[$prog_c][1]

	$byte_c[$prog_c]=0
	$cycle_c[$prog_c]=0
	puts "...................................................................................................."
	puts $prg_title[$prog_c]
	end

#LABELS
def label l_name
	puts l_name
	$l_hash[l_name]=$s_start+$byte_c[$prog_c]
	end

#BUILD PROGRAM
def build
	puts "...................................................................................................."
	puts "building..."
	$p_count=$prog_c
	$prog_c=0
	for $prog_c in (0..$p_count)
		$b_count=0
	
		for $b_count in (0..$byte_c[$prog_c])
		
			if $assem[$prog_c][$b_count].is_a? String
				
				if $assem[$prog_c][$b_count]=="label"
				
					hi = $l_hash[$assem[$prog_c][$b_count+1]]/256
					low = $l_hash[$assem[$prog_c][$b_count+1]]-(hi*256)
				
					$assem[$prog_c][$b_count]=low
					$assem[$prog_c][$b_count+1]=hi
					$b_count+=1			
				
				elsif $assem[$prog_c][$b_count][0]=="!"
						$assem[$prog_c][$b_count][0]=""
						brn1=$l_hash[$assem[$prog_c][$b_count]]
						brn2=$start_l_h[$prog_c][1]*256+$start_l_h[$prog_c][0]+$b_count	
							
							
							if brn1>brn2							
							$assem[$prog_c][$b_count]=brn1-brn2
							
							else $assem[$prog_c][$b_count]=255-(brn2-brn1)
								
								end
							
				else $assem[$prog_c][$b_count]=$l_hash[$assem[$prog_c][$b_count]]
					
					if $assem[$prog_c][$b_count]>255
						puts $e_call[1]
						puts "@#{$assem[$prog_c][$b_count]}"
						er=gets
						end
					
					end	

				end
			end
		end
		

	$prog_c=0
	for $prog_c in (0..$p_count)
		puts "...................................................................................................."
		puts "Include start address for\n   #{$prg_title[$prog_c]}?\n     y=yes\n     n=no"
		er=gets.chomp
			if er=="y"
				$assem[$prog_c].insert(0,$start_l_h[$prog_c])
				end
		puts "...................................................................................................."
		puts "building #{$prg_title[$prog_c]}"
		puts "...................................................................................................."
		puts $assem[$prog_c]
		end
	
	puts "...................................................................................................."
	puts "build complete!"
	er=gets

	end	

def pr_info x4,x5
	
	$assem [$prog_c][$byte_c[$prog_c]]=x5
	puts "#{x5}\t byte: #{$byte_c[$prog_c]}\t cycles: #{x4}\t total cycles: #{$cycle_c[$prog_c]}\t address: #{$s_start+$byte_c[$prog_c]}"    
	
	$byte_c[$prog_c]+=1
	end

def data *d_val
	for t in (0...d_val.length)
		pr_info 0,d_val[t]
		end
	end

class Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	
	def self.out
		
		$cycle_c[$prog_c]+=@@cycle
		
		if $start_l_h[$prog_c][0]+@@byte>256
			$cycle_c[$prog_c]+=@@cycalt
			end	
	
		pr_info @@cycle,@@command
	
	
	
		if @@byte==3
			if @@value.is_a? String
				low="label"
				hi=@@value			
				else hi=@@value/256
					low=@@value-(hi*256)
				end	
		
			if low.is_a? Integer
				if low>255
					er_rep 1
					end
				end
		
				pr_info @@cycle,low
				@@value=hi
	
				elsif @@value.is_a? Integer
					if @@value>255
						er_rep 1
						end
			end
		if @@byte>1
			pr_info @@cycle,@@value
			
			end
		print "\n"	
	end	


	
	
	
=begin	def self.out
	puts @@command
	puts @@value
	puts @@cycle
	puts @@cycalt
	puts @@byte
		end
=end	
	def self.ix value
		er_rep 1
		er=gets
		end
	def self.zp value
		er_rep 1
		er=gets
		end
	def self.im value
		er_rep 1
		er=gets
		end
	def self.ab value
		er_rep 1
		er=gets
		end
	def self.iy value
		er_rep 1
		er=gets
		end
	def self.zy value
		er_rep 1
		er=gets
		end
	def self.zx value
		er_rep 1
		er=gets
		end
	def self.ay value
		er_rep 1
		er=gets
		end
	def self.ax value
		er_rep 1
		er=gets
		end
	def self.in value
		er_rep 1
		er=gets
		end
	def self.rl value
		er_rep 1
		er=gets
		end
	def self.ip
		er_rep 1
		er=gets
		end
	
	end
class Branch<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@value=value
		@@cycle=2
		@@cycalt=1
		@@byte=2
		
		if @@value.is_a? String
			@@value="!" + @@value
			end
		Opcode.out ###switch to Branch.rl_out for relative addressing
		end
	end
class Adc<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=97
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=101
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=105
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=109
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=113
		@@value=value
		@@cycle=5
		@@cycalt=1
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=117
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=121
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=125
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class And<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=33
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=37
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=41
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=45
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=49
		@@value=value
		@@cycle=5
		@@cycalt=
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=53
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=57
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=61
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	end
class Asl<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=6
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ip
	    @@command=10
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	def self.ab value
		@@command=14
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.zx value
		@@command=22
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ax value
		@@command=30
		@@value=value
		@@cycle=7
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	end
class Bcc<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=144
		super
		end
	end
class Bcs<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=176
		super
		end
	end
class Beq<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=240
		super
		end
	end
class Bit<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0

	def self.zp value
		@@command=36
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=44
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	end
class Bmi<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=48
		super
		end
	end
class Bne<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=208
		super
		end
	end
class Bpl<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=16
		super
		end
	end
class Brk<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=0
		@@value=nil
		@@cycle=7
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Bvc<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=80
		super
		end
	end
class Bvs<Branch 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.rl value
		@@command=112
		super
		end
	end
class Clc<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=24
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Cld<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=216
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Cli<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=88
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Clv<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=184
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Cmp<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=193
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=197
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=201
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=205
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=209
		@@value=value
		@@cycle=5
		@@cycalt=1
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=213
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=217
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=221
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Cpx<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=228
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=224
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=236
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	end
class Cpy<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=196
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=192
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=204
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	end
class Dec<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=198
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=214
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=206
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=222
		@@value=value
		@@cycle=7
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	end
class Dex<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=202
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		end
	end
class Dey<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=136
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		end
	end
class Eor<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=65
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=69
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
	
		@@command=73
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=77
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=81
		@@value=value
		@@cycle=5
		@@cycalt=1
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=85
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=89
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=93
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Inc<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=230
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=246
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=238
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=254
		@@value=value
		@@cycle=7
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	end
class Inx<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=232
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		end
	end
class Iny<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=200
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Jmp<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ab value 
		@@command=76
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.in value 
		@@command=108
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	end
class Jsr<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ab value 
		@@command=32
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	end
class Lda<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=161
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=165
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
	
		@@command=169
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=173
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=177
		@@value=value
		@@cycle=5
		@@cycalt=1
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=191
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=185
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=189
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Ldx<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=166
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=162
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=174
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.zy value
		@@command=182
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=190
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	end
class Ldy<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=164
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=160
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=172
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	
	def self.zx value
		@@command=180
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end

	def self.ax value
		@@command=188
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Lsr<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=70
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ip
		@@command=74
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	def self.ab value
		@@command=78
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.zx value
		@@command=86
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ax value
		@@command=94
		@@value=value
		@@cycle=7
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Nop<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=234
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Ora<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=1
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=5
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
	    @@command=9
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=13
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=17
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=21
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=25
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=29
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Pha<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=72
		@@value=nil
		@@cycle=3
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Php<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=8
		@@value=nil
		@@cycle=3
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Pla<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=10
		@@value=nil
		@@cycle=4
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Plp<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=40
		@@value=nil
		@@cycle=4
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Rol<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=38
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ip
	    @@command=42
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	def self.ab value
		@@command=6
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.zx value
		@@command=54
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ax value
		@@command=62
		@@value=value
		@@cycle=7
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	end
class Ror<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=102
		@@value=value
		@@cycle=5
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ip
	    @@command=106
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	def self.ab value
		@@command=110
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.zx value
		@@command=118
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ax value
		@@command=126
		@@value=value
		@@cycle=7
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	end
class Rti<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=64
		@@value=nil
		@@cycle=6
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Rts<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=96
		@@value=nil
		@@cycle=6
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Sbc<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=225
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=229
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.im value
		@@command=233
		@@value=value
		@@cycle=2
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=237
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=241
		@@value=value
		@@cycle=5
		@@cycalt=1
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=245
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=249
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=253
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Sec<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=56
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Sed<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=248
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Sei<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=120
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Sta<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ix value
		@@command=129
		@@value=value
		@@cycle=6
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.zp value
		@@command=133
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=141
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.iy value
		@@command=145
		@@value=value
		@@cycle=6
		@@cycalt=1
		@@byte=2
		Opcode.out
		end
	def self.zx value
		@@command=149
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ay value
		@@command=153
		@@value=value
		@@cycle=4
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	def self.ax value
		@@command=157
		@@value=value
		@@cycle=5
		@@cycalt=1
		@@byte=3
		Opcode.out
		end
	
	end
class Stx<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=134
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=141
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.zy value
		@@command=150
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	
	end
class Sty<Opcode 
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.zp value
		@@command=132
		@@value=value
		@@cycle=3
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	def self.ab value
		@@command=140
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=3
		Opcode.out
		end
	def self.zx value
		@@command=148
		@@value=value
		@@cycle=4
		@@cycalt=0
		@@byte=2
		Opcode.out
		end
	end
class Tax<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=170
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Tay<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=168
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Tsx<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=186
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		end
	end
class Txa<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=138
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Txs<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=154
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
class Tya<Opcode
	@@command=0
	@@value=0
	@@cycle=0
	@@cycalt=0
	@@byte=0
	def self.ip 
		@@command=152
		@@value=nil
		@@cycle=2
		@@cycalt=0
		@@byte=1
		Opcode.out
		end
	end
