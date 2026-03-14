String optimizeImage(String url) {

  if (!url.contains("cloudinary")) return url;

  return url.replaceFirst(
    "/upload/",
    "/upload/w_800,q_auto,f_auto/",
  );
}