--**************************************************************
--
-- User library
--
--**************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package userlib is

--**************************************************************
--
-- Functions/Procedures for type conversions between std_logic_vector, 
-- unsigned, integer 
--
-- NOTE: types std_logic_vector,unsigned become interchangeble
--
-- std_logic_vector = SLV(integer, length)  
-- std_logic_vector = SLV(integer, std_logic_vector)  
-- std_logic_vector = SLV(std_logic_vector, length)  
-- std_logic_vector = SLV(unsigned, length) 
--
-- unsigned         = SLV(integer, length) 
-- unsigned         = SLV(integer, unsigned)  
-- unsigned         = SLV(std_logic_vector, length) 
-- unsigned         = SLV(unsigned, length) 
-- unsigned         = SLV(std_logic_vector)
-- unsigned         = SLV(unsigned) 
--
-- natural          = UINT(std_logic_vector) 
-- natural          = UINT(unsigned) 
--

function SLV(n : IN integer; size : IN integer) return std_logic_vector;
function SLV(n : IN integer; vect : IN std_logic_vector) return std_logic_vector;
function SLV(vect : IN std_logic_vector; size : IN integer) return std_logic_vector;
function SLV(vect : IN unsigned; size : IN integer) return std_logic_vector;

function SLV(n : IN integer; size : IN integer) return unsigned;
function SLV(n : IN integer; vect : IN unsigned) return unsigned;
function SLV(vect : IN std_logic_vector; size : IN integer) return unsigned;
function SLV(vect : IN unsigned; size : IN integer) return unsigned;

-- Copy functions 
function SLV(vect: std_logic_vector) return unsigned;
function SLV(vect: unsigned) return unsigned;
--function SLV(vect: std_logic_vector) return std_logic_vector;

function UINT(vect: unsigned) return natural;
function UINT(vect: std_logic_vector) return natural;

--
-- Procedures for assignment operations to variables
-- NOTE: functions 'SLV' needs 'length' argument --> 'Set' procedure does not
-- duplicates vector-names
-- 
-- Set(std_logic_vector, integer)
-- Set(std_logic_vector, unsigned)
-- Set(std_logic_vector, std_logic_vector)
--
-- Set(unsigned, integer)
-- Set(unsigned, unsigned)
-- Set(unsigned, std_logic_vector)
--

-- std_logic_vector type
procedure Set(variable dest : out std_logic_vector; constant n : in integer);
procedure Set(variable dest : out std_logic_vector; constant n : in unsigned);
procedure Set(variable dest : out std_logic_vector; constant n : in std_logic_vector);

-- unsigned type
procedure Set(variable dest : out unsigned; constant n : in integer);
procedure Set(variable dest : out unsigned; constant n : in unsigned);
procedure Set(variable dest : out unsigned; constant n : in std_logic_vector);

--
-- Functions for array rotation
--
function REVERSE(vect: std_logic_vector) return std_logic_vector;

end userlib;

package body userlib is

-- constant to std_logic_vector (standard version)
function SLV(n : IN integer; size : IN integer) return std_logic_vector is
begin
   --NOTE: CONV_STD_LOGIC_VECTOR --> library std_logic_arith 
   --return CONV_STD_LOGIC_VECTOR(n, size);
   return STD_LOGIC_VECTOR(TO_UNSIGNED(n, size));
end function;

-- constant to std_logic_vector (vector argument works as 'length' param)
function SLV(n : IN integer; vect : IN std_logic_vector) return std_logic_vector is
begin
   --NOTE: CONV_STD_LOGIC_VECTOR --> library std_logic_arith 
   --return CONV_STD_LOGIC_VECTOR(n, vect'length);
   return STD_LOGIC_VECTOR(TO_UNSIGNED(n, vect'length));
end function;

-- Resize(std_logic_vector) --> std_logic_vector result
function SLV(vect : IN std_logic_vector; size : IN integer) return std_logic_vector is
begin
--   if size < vect'length then
--      assert (1 = 0)
--      report "Warning: bits are lost during conversion"
--      severity WARNING;      
--   end if;
   return STD_LOGIC_VECTOR(RESIZE(unsigned(vect), size));
end function;

-- Resize(unsigned) --> std_logic_vector result
function SLV(vect : IN unsigned; size : IN integer) return std_logic_vector is
begin
   return STD_LOGIC_VECTOR(RESIZE(vect, size));
end function;

-- constant to unsigned (standard version)
function SLV(n : IN integer; size : IN integer) return unsigned is
begin
   --NOTE: CONV_STD_LOGIC_VECTOR --> library std_logic_arith 
   --return CONV_STD_LOGIC_VECTOR(n, size);
   return TO_UNSIGNED(n, size);
end function;

-- constant to unsigned (vector argument works as 'length' param)
function SLV(n : IN integer; vect : IN unsigned) return unsigned is
begin
   return TO_UNSIGNED(n, vect'length);
end function;

-- Resize(std_logic_vector) --> result unsigned
function SLV(vect : IN std_logic_vector; size : IN integer) return unsigned is
begin
   return RESIZE(unsigned(vect), size);
end function;

-- Resize(unsigned) --> result unsigned
function SLV(vect : IN unsigned; size : IN integer) return unsigned is
begin
   return RESIZE(vect, size);
end function;

--
-- Copy functions 
--

-- std_logic_vector --> unsigned (standard version)
function SLV(vect: std_logic_vector) return unsigned is
begin
   return unsigned(vect);
end function;

---- Conversione unsigned->std_logic_vector
---- versione standard
--function SLV(vect: unsigned) return std_logic_vector is
--begin
--   return std_logic_vector(vect);
--end function;
-- NOTA: questa conversione puo' creare side effects senza alcuna
-- segnalazione di errore quando si confrontano tra loro vettori
-- unsigned e std_logic_vector (esempio: unsigned >= SLV(std_logic_vector),
-- se la funzione viene applicata all'operando sbagliato si ottiene
-- SLV(unsigned) >= std_logic_vector e il confronto diventa tra vettori
-- std_logic_vector che possono avere dimensioni diverse --> diventa un
-- confronto tra stringhe di lunghezza diversa che e' perfettamente
-- legale ma che combina range completamente diversi). 
-- Tutte le conversioni dirette senza specifica della dimensione hanno il 
-- tipo unsigned come risultato, ogni conversione verso std_logic_vector 
-- richiede la size. 

function SLV(vect: unsigned) return unsigned is
begin
   return vect;
end function;

--function SLV(vect: std_logic_vector) return std_logic_vector is
--begin
--   return vect;
--end function;
-- NOTA: per evitare di confrontare vettori std_logic_vector in
-- modo errato anche applicando la SLV, questa copy function  
-- viene disabilitata (tutte le conversioni senza specifica della
-- dimensione restituiscono un unsigned).

function UINT(vect: unsigned) return natural is
begin
   return TO_INTEGER(vect);
end function;

function UINT(vect: std_logic_vector) return natural is
begin
   return TO_INTEGER(UNSIGNED(vect));
end function;

--
-- Procedures for assignment operations to variables
-- NOTE: functions 'SLV' needs 'length' argument --> 'Set' procedure does not
-- duplicates vector-names
-- 
-- Set(std_logic_vector, integer)
-- Set(std_logic_vector, unsigned)
-- Set(std_logic_vector, std_logic_vector)
--
-- Set(unsigned, integer)
-- Set(unsigned, unsigned)
-- Set(unsigned, std_logic_vector)
--

-- std_logic_vector type
procedure Set(variable dest : out std_logic_vector; constant n : in integer) is
begin
   dest := SLV(n, dest'length);
end procedure;
procedure Set(variable dest : out std_logic_vector; constant n : in unsigned) is
begin
   dest := SLV(n, dest'length);
end procedure;
procedure Set(variable dest : out std_logic_vector; constant n : in std_logic_vector) is
begin
   dest := SLV(n, dest'length);
end procedure;

-- unsigned type
procedure Set(variable dest : out unsigned; constant n : in integer) is
begin
   dest := SLV(n, dest'length);
end procedure;
procedure Set(variable dest : out unsigned; constant n : in unsigned) is
begin
   dest := SLV(n, dest'length);
end procedure;
procedure Set(variable dest : out unsigned; constant n : in std_logic_vector) is
begin
   dest := SLV(n, dest'length);
end procedure;

--
-- Functions for array rotation
--
function REVERSE(vect : std_logic_vector) return std_logic_vector is
variable ret : std_logic_vector(vect'range);
begin
   for i in vect'low to vect'high loop
      ret(vect'high - (i - vect'low)) := vect(i);
   end loop;
   return ret;
end function;

end userlib;

