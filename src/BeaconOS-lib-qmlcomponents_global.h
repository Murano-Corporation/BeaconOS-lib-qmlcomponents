#ifndef BEACONOSLIBQMLCOMPONENTS_GLOBAL_H
#define BEACONOSLIBQMLCOMPONENTS_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(BEACONOSLIBQMLCOMPONENTS_LIBRARY)
#  define BEACONOSLIBQMLCOMPONENTS_EXPORT Q_DECL_EXPORT
#else
#  define BEACONOSLIBQMLCOMPONENTS_EXPORT Q_DECL_IMPORT
#endif

#endif // BEACONOSLIBQMLCOMPONENTS_GLOBAL_H
