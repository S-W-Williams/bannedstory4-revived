package ion.utils.swf.tags
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import ion.utils.swf.tags.core.BasicTag;
   
   public class FileAttributes extends BasicTag
   {
      public function FileAttributes()
      {
         super();
         _type = FILE_ATTRIBUTES;
      }
      
      override public function get serialize() : ByteArray
      {
         _bytes = new ByteArray();
         _bytes.endian = Endian.LITTLE_ENDIAN;
         ui8(8);
         ui16(0);
         ui8(0);
         var _loc1_:ByteArray = buildRecordHeader();
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         _loc2_.writeBytes(_loc1_,0,_loc1_.length);
         _loc2_.writeBytes(_bytes,0,_bytes.length);
         return _loc2_;
      }
   }
}

