/*
 * JNI_Position.h
 *
 *  Created on: 02 ���. 2015 �.
 *      Author: imizus
 */

#ifndef CPP_DEMO_JNI_FONT_METRICS_H_
#define CPP_DEMO_JNI_FONT_METRICS_H_

#include <jni.h>

jobject fontMetricsFromNative(JNIEnv* env, const litehtml::font_metrics& fm);
litehtml::font_metrics fontMetricsToNative(JNIEnv* env, jobject jfm);

#endif /* CPP_DEMO_JNI_POSITION_H_ */
