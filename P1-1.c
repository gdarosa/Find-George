/*  This program finds George in a crowd.

 10/1/2017                   Gabriel Darosa
*/

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
   int	             CrowdInts[1024];
   int	             NumInts, TopLeft, BottomRight;
   int               Load_Mem(char *, int *);

   if (argc != 2) {
     printf("usage: ./P1-1 valuefile\n");
     exit(1);
   }
   NumInts = Load_Mem(argv[1], CrowdInts);
   if (NumInts != 1024) {
      printf("valuefiles must contain 1024 entries\n");
      exit(1);
   }

   /* your code goes here. */
   char * ptr = (char *)CrowdInts;
   int offset = (581);
   int offset_offset;
   int col_spot_check = 1;
   int scale;
   int width;
   int pixel;

   do // start of search for the terrorist, George
   {
     pixel = *(ptr + offset);
     if (pixel <= 8) // what to do if a face is found
     {
       offset_offset = 1;
       pixel = *(ptr + offset + offset_offset);
       width = 1;
       while (pixel <= 8) // next 2 while loops get width of George at that row
       {
         width++;
         offset_offset++;
         pixel = *(ptr + offset + offset_offset);
       }
       offset_offset -= (width + 1);
       pixel = *(ptr + offset + offset_offset);
       while (pixel <= 8)
       {
         width++;
         offset_offset--;
         pixel = *(ptr + offset + offset_offset);
       }
       offset_offset += (width / 2); // at middle pixel
       pixel = *(ptr + offset + offset_offset);
       while (pixel <=8 && pixel != 7) // journey down to collar
       {
         offset_offset += 64;
         pixel = *(ptr + offset + offset_offset);
       }
       while (pixel == 7)
       {
         offset_offset -= 64; // just above the collar
         pixel = *(ptr + offset + offset_offset);
       }
       if (pixel == 5)
       {
         scale = 1;
         offset_offset++;
         while (pixel <= 5) // next 2 while loops get width of George's neck for the scale
         {
           scale++;
           offset_offset++;
           pixel = *(ptr + offset + offset_offset);
         }
         offset_offset -= scale;
         pixel = *(ptr + offset + offset_offset);
         while (pixel <= 5)
         {
           scale++;
           offset_offset--;
           pixel = *(ptr + offset + offset_offset);
         }
         offset_offset++;
         scale /= 3;
         if(*(ptr + offset + offset_offset - (319 * scale)) == 5 &&
            *(ptr + offset + offset_offset - (318 * scale)) == 3 &&
            *(ptr + offset + offset_offset - (446 * scale)) == 1 &&
            *(ptr + offset + offset_offset - (510 * scale)) == 2 &&
            *(ptr + offset + offset_offset - (189 * scale)) == 8) // tests for features
         {
           TopLeft = offset + offset_offset - 708 * scale + 64;
           BottomRight = offset + offset_offset + 72 * scale - 1;
           break;
         }
       }
     }
     offset += 7; // moving on to next grid's pixel to check
     if (col_spot_check == 9)
     {
       offset += (513);
       col_spot_check = 0;
     }
     col_spot_check++;
   } while (offset <= 3709);
// end my code

   printf("George is located at: top left pixel %4d, bottom right pixel %4d.\n", TopLeft, BottomRight);
   exit(0);
}

/* This routine loads in up to 1024 newline delimited integers from
a named file in the local directory. The values are placed in the
passed integer array. The number of input integers is returned. */

int Load_Mem(char *InputFileName, int IntArray[]) {
   int	N, Addr, Value, NumVals;
   FILE	*FP;

   FP = fopen(InputFileName, "r");
   if (FP == NULL) {
      printf("%s could not be opened; check the filename\n", InputFileName);
      return 0;
   } else {
      for (N=0; N < 1024; N++) {
         NumVals = fscanf(FP, "%d: %d", &Addr, &Value);
         if (NumVals == 2)
            IntArray[N] = Value;
         else
            break;
      }
      fclose(FP);
      return N;
   }
}
