// Author - Vincent Lui

public Class checkRecursive{
    private static boolean bRun = true;
    
    public static void SetRunFlag(boolean bFlag) {
        bRun = bFlag;
    }
    
    public static boolean runOnce(){
        if(bRun){
             bRun=false;
             return true;
        }else{
            return bRun;
        }
    }
}