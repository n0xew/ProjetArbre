import processing.core.PApplet;
import processing.core.PImage;
import java.util.*;


public class Step2 extends PApplet{ 
  PImage img;
  PImage result;
  ArrayList<Integer> bestCandidates=new ArrayList<Integer>();
  
  public void setup(){
    size(800,600);
   img = loadImage("board1.jpg");
    image(img,0,0);
    hough(Sobel((img)));
    
    
       //noLoop();
  }
  
  
 public PImage Sobel(PImage img){
 PImage preResult = createImage(img.width, img.height, ALPHA);
 float[][] hKernel = {{0,1,0},
                      {0,0,0},
                     {0,-1,0}};
  float[][] vKernel = {{0,0,0},
                      {1,0,-1},
                     {0,0,0}};
   int pixelHue;
   int pixelBright;
   float minColor = 100;
   float maxColor = 130;
   float minBright = 20;
   float maxBright = 110;
   for(int x=1; x<img.width-1; x++){
    for(int y=1; y<img.height-1; y++){
      pixelHue = (int)hue(img.pixels[y*img.width + x]);
      pixelBright = (int)brightness(img.pixels[y*img.width +x ]);
      if(pixelHue>maxColor || pixelHue <minColor || pixelBright < minBright || pixelBright>maxBright){
      preResult.pixels[y*img.width + x] = color(0);    
      }else {
        preResult.pixels[y*img.width + x] = color(255);
      }
  }
 
  }
   
                     
   PImage result = createImage(img.width, img.height, ALPHA);
   
   float max=0;
   float[] buffer = new float[img.width*img.height];
   
   int N = 3;

  for(int x=1; x<img.width-1; x++){
    for(int y=1; y<img.height-1; y++){
      float sumh = 0;
      float sumv = 0;           
      for(int a=-N/2;a<=N/2 ;a++){
        for(int b=-N/2;b<=N/2 ;b++){
         sumh += brightness(preResult.pixels[(x+a)+(y+b)*img.width])*hKernel[a+N/2][b+N/2];  
         sumv += brightness(preResult.pixels[(x+a)+(y+b)*img.width])*vKernel[a+N/2][b+N/2];  
        }
      }
      double sum = sqrt(pow(sumh, 2)+pow(sumv, 2));
      buffer[y*img.width+x] = (float)sum;
      if(sum>max){
      max = (float)sum;
      }
      
    }
  }
   for(int y =2; y<img.height-2; y++){   
     for(int x =2; x<img.width-2; x++){
       if(buffer[y*img.width+x]>(int)(max *0.3f)){
         result.pixels[y*img.width+x] = color(255);
       }else{
         result.pixels[y*img.width+x] = color(0);
       }
     }
   }                     
  return result;
}
  
  
  
  
public void hough(PImage img) {
 
 
 float discretizationStepsPhi =0.02f;
 float discretizationStepsR = 2.5f;

 int phiDim = (int) (Math.PI / discretizationStepsPhi);
 int rDim = (int) (((img.width + img.height)*2 + 1) / discretizationStepsR);
 
 int[] accumulator = new int [(phiDim +2 ) * (rDim + 2)];
 
 for(int y=0 ; y<img.height ;y++) {
   for(int x=0 ;x<img.width;x++){
     if(brightness(img.pixels[y*img.width + x]) != 0) {
       int r =0;
       int phi =0;
       double Rmax = 0;
       for(phi=0 ;phi< phiDim ;phi++) {
         r = (int)Math.round(x * cos(phi*discretizationStepsPhi) + y* sin(phi*discretizationStepsPhi));
         r=(int)(r/(discretizationStepsR) + (rDim+1)/2);
         accumulator[phi*(rDim+2)+r]+=1;      
      }        
    }
   } 
 }
 /*  for(int idx=0;idx<accumulator.length ;idx++) {
    if(accumulator[idx]>200){
      bestCandidates.add(idx);
    }
   }*/
   //Here begin the optimization
   
   int neighbourhood = 10;

int minVotes = 200;

for(int accR = 0; accR<rDim; accR++){
  for(int accPhi=0; accPhi<phiDim; accPhi++){
    int idx = (accPhi+1)*(rDim+2) + accR + 1;
    if(accumulator[idx] > minVotes){
      boolean bestCandidate = true;
      for(int dPhi=-neighbourhood/2;dPhi<neighbourhood/2 + 1; dPhi++){
        if(accPhi+dPhi<0 || accPhi+dPhi >= phiDim) continue;
        for(int dR = -neighbourhood/2; dR<neighbourhood/2 +1;dR++){
          if(accR+dR<0 || accR + dR>=rDim) continue;
          int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
          if(accumulator[idx]<accumulator[neighbourIdx]){
            bestCandidate=false;
            break;
          }
        }if(!bestCandidate) break;
      }
      if(bestCandidate){
        bestCandidates.add(idx);
      }
    }
  }
}
   //Here it ends
 Collections.sort(bestCandidates, new HoughComparator(accumulator));
 int nLines = 8;
 for(int i=0; i<nLines;i++){
      int accPhi = (int) (bestCandidates.get(i) / (rDim+2)) -1;
      int accR = bestCandidates.get(i) - (accPhi +1) * (rDim+2) -1;
      float r =(accR- (rDim-1) *0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      
      int x0=0;
      int y0=(int) (r/sin(phi));
      int x1= (int) (r/cos(phi));
      int y1 =0;
      int x2 = img.width;
      int y2 = (int) (-cos(phi) / sin(phi) *x2+r /sin(phi));
      int y3 = img.width;
      int x3 = (int)(-(y3-r/sin(phi)) * (sin(phi) /cos(phi)));
      
      stroke(204,102,0);
      if(y0>0){
        if(x1>0)
          line(x0,y0,x1,y1);
        else if(y2>0)
           line(x0,y0,x2,y2);
        else
           line(x0,y0,x3,y3);
      }
      else {
        if(x1>0) {
          if(y2 >0)
            line(x1,y1,x2,y2);
          else
            line(x1,y1,x3,y3);
          }
         else   
         line(x2,y2,x3,y3); 
      } 
 }/*
  for(int idx=0;idx<accumulator.length ;idx++) {
    if(accumulator[idx]>200){
      int accPhi = (int) (idx / (rDim+2)) -1;
      int accR = idx - (accPhi +1) * (rDim+2) -1;
      float r =(accR- (rDim-1) *0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      
      int x0=0;
      int y0=(int) (r/sin(phi));
      int x1= (int) (r/cos(phi));
      int y1 =0;
      int x2 = img.width;
      int y2 = (int) (-cos(phi) / sin(phi) *x2+r /sin(phi));
      int y3 = img.width;
      int x3 = (int)(-(y3-r/sin(phi)) * (sin(phi) /cos(phi)));
      
      stroke(204,102,0);
      if(y0>0){
        if(x1>0)
          line(x0,y0,x1,y1);
        else if(y2>0)
           line(x0,y0,x2,y2);
        else
           line(x0,y0,x3,y3);
      }
      else {
        if(x1>0) {
          if(y2 >0)
            line(x1,y1,x2,y2);
          else
            line(x1,y1,x3,y3);
          }
         else   
         line(x2,y2,x3,y3); 
      }  
    }
  }*/
 }



class HoughComparator implements Comparator<Integer> {
 int[] acc;
 public HoughComparator(int[] acc){
   this.acc=acc;
 }
 @Override
 public int compare(Integer l1, Integer l2){
   if(acc[l1]>acc[l2] ||acc[l1]==acc[l2] &&l1<l2){
     return -1;
   }
   return 1;
 } 
}
}