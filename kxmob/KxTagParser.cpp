#include "KxTagParser.h"
#include "taglib/tag.h"
#include "taglib/mpeg/mpegfile.h"
#include "taglib/fileref.h"
#include <QDebug>
#include <QFile>

KxTagParser::KxTagParser(QObject *parent)
    :QObject(parent)
{

}

QVariant KxTagParser::get(const QString &file) const
{
    if(!isSupportFormat(file)){
        return false;
    }
    TagLib::FileRef fr(file.toLocal8Bit().data(), false, TagLib::AudioProperties::Fast);
    if(fr.isNull())
        return false;
    QVariantMap data;
    TagLib::Tag* tag = fr.tag();
    if(tag){
        data.insert("title", tag->title().toCString());
        data.insert("artist", tag->artist().toCString());
        data.insert("album", tag->album().toCString());
        data.insert("genre", tag->genre().toCString());
        data.insert("comment", tag->comment().toCString());
        data.insert("year", tag->year());
        data.insert("track", tag->track());
    }
    TagLib::AudioProperties* ap = fr.audioProperties();
    if(ap){
        data.insert("bitrate", ap->bitrate());
        data.insert("channels", ap->channels());
        data.insert("playLength", ap->length() * 1000);
        data.insert("sampleRate", ap->sampleRate());
    }
    return QVariant(data);
}

bool KxTagParser::isSupportFormat(const QString &file) const
{
    const char *exts[] = {".mp3", ".wma", ".ogg", ".wav", ".flac"};
    int idx = file.lastIndexOf('.');
    if(idx < 0){
        return false;
    }
    QString ext = file.mid(idx);
    for(int i = 0; i < (sizeof(exts) / sizeof(exts[0])); i++){
        if(ext.compare(exts[i], Qt::CaseInsensitive) == 0){
            return true;
        }
    }
    return false;
}
